require 'net/https'

class RhymeGenerator
  def initialize(user_text)
    @user_text = user_text
  end

  def get_rhyme
    txt = ''

    noun = ''
    nm = Natto::MeCab.new
    nm.parse(@user_text) do |_t|
      noun = _t.surface if _t.feature.match('名詞')
    end
    noun = @user_text if noun.blank?

    words = get_stamp_words(noun)

    SCRIPTS.shuffle.each do |s|
      script = @user_text + s

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

  private

  def get_stamp_words(seed)
    words = []

    url = URI.parse('https://kujirahand.com/web-tools/Words.php')
    res = Net::HTTP.start(url.host, url.port, use_ssl: true) {|http|
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
end
