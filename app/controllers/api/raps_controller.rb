class Api::RapsController < ApplicationController
  require 'line/bot'

  before_action :parse_event_params

  def battle
    @events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event['message']['type']
        when Line::Bot::Event::MessageType::Text
          rhyme = get_rhyme(event.message['text'])
          if Rails.env.production?
            msg = { type: 'text', text: rhyme }
            result = line_client.reply_message(@reply_token, msg)
            print_line_post_result(result)
          else
            puts rhyme
          end
        end
      end
    end
    render json: {}, status: :ok
  end

  private

  def line_client
    @line_client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end

  def get_events_from_request
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    if Rails.env.production? && !line_client.validate_signature(body, signature)
      raise 'Bad Request'
    end

    line_client.parse_events_from(body)
  end

  def parse_event_params
    @events = get_events_from_request
    @reply_token  = @events[0]['replyToken']
    logger.debug "evnets: " + @events.inspect
  end

  def print_line_post_result(result)
    case result
    when Net::HTTPSuccess, Net::HTTPRedirection
      logger.info "LINE POST: OK"
    else
      logger.error "\n\nLINE POST: NG ///////////////////////"
      logger.error result.body
      logger.error "/////////////////////////////////////\n\n"
    end
  end

  def get_stamp_words(seed)
    words = []

    url = URI.parse('http://kujirahand.com/web-tools/Words.php')
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.get('/web-tools/Words.php?m=boin-search&key=' + URI.escape(seed) + '&opt=usiro&len=%3F')
    }
    doc = Nokogiri::HTML.parse(res.body)

    li_elems = doc.xpath('//ul[@id="word_result"]/li')
    li_elems.each do |li_elem|
      words << li_elem.at('ruby').children[0].text if li_elem.at('ruby')
    end
    if words.empty?
      words = %w( アップデート チョコレート chocolate オンパレード デート グレート ノミネート レート トルネード パレード スケート sk8 スケート テンプレート X PLATE グレネード それでも グレード ステレオ バリケード コーディネート ベイブレード ディベート STAIREO Stereo CD トレード けれど アンケート ゲート)
    end

    words
  end

  def get_rhyme(user_text)
    txt = ''

    noun = ''
    nm = Natto::MeCab.new
    nm.parse(user_text) do |_t|
      noun = _t.surface if _t.feature.match('名詞')
    end
    noun = user_text if noun.blank?

    words = get_stamp_words(noun)

    SCRIPTS.shuffle.each do |s|
      script = user_text + s

      rhymer = Rhymer::Parser.new(script)
      nouns = rhymer.lyric.lyric.select {|l| l.feature.match('名詞')}.map(&:surface)

      words.each do |w|
        break if rhymer.rhymes.present?
        script.sub!(nouns.sample, w)
        puts script
        rhymer = Rhymer::Parser.new(script)
      end

      rhymer.rhymes.each do |rhyme|
        txt = [rhyme[0], rhyme[1]].join(" ")
      end
      return txt if txt.present?
    end
  end
end
