class Api::RapsController < ApplicationController
  require 'line/bot'

  before_action :parse_event_params

  def battle
    @events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event['message']['type']
        when Line::Bot::Event::MessageType::Text
          t = event.message['text']
          script = t + SCRIPTS.sample

          noun = ''
          nm = Natto::MeCab.new
          nm.parse(t) do |_t|
            noun = _t.surface if _t.feature.match('名詞')
          end

          url = URI.parse('http://kujirahand.com/web-tools/Words.php')
          res = Net::HTTP.start(url.host, url.port) {|http|
            http.get('/web-tools/Words.php?m=boin-search&key=' + URI.escape(noun) + '&opt=usiro&len=%3F')
          }
          doc = Nokogiri::HTML.parse(res.body)

          words = []
          li_elems = doc.xpath('//ul[@id="word_result"]/li')
          li_elems.each do |li_elem|
            words << li_elem.at('ruby').children[0].text if li_elem.at('ruby')
          end
          if words.empty?
            words = %w( アップデート チョコレート chocolate オンパレード デート グレート ノミネート レート トルネード パレード スケート sk8 スケート テンプレート X PLATE グレネード それでも グレード ステレオ バリケード コーディネート ベイブレード ディベート STAIREO Stereo CD トレード けれど アンケート ゲート)
          end

          txt = ''
          rhymer = Rhymer::Parser.new(script)
          nouns = rhymer.lyric.lyric.select {|l| l.feature.match('名詞')}.map(&:surface)

          100.times do
            break if rhymer.rhymes.present?
            script.sub!(nouns.sample, words.sample)
            rhymer = Rhymer::Parser.new(script)
          end

          rhymer.rhymes.each do |rhyme|
            txt = [rhyme[0], rhyme[1]].join(" ")
          end

          puts txt

          #msg = { type: 'text', text: txt }
          #result = line_client.reply_message(@reply_token, msg)
          #print_line_post_result(result)
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
end
