class RhymeEvaluator
  def self.length_score(str1, str2)
    max      = [str1.size, str2.size].max
    abs_diff = (str1.size - str2.size).abs
    1.0 - (abs_diff.to_f / max.to_f)
  end

  def self.end_rhyme_score(str1, str2)
    vowels_str1 = vowelize(str1)
    vowels_str2 = vowelize(str2)

    comp_len = [vowels_str1.size, vowels_str2.size].min
    sub_vowels_str1 = vowels_str1.split(//).last(comp_len).join
    sub_vowels_str2 = vowels_str2.split(//).last(comp_len).join

    cnt = 0

    comp_len.times do |i|
      cnt += 1 if sub_vowels_str1[i] == sub_vowels_str2[i]
    end

    cnt
  end

  private

  def self.vowelize(str)
    parser = Rhymer::Parser.new(str)
    kanas = parser.lyric.lyric.map {|l| l.feature.split(',')[7]}
    kanas.pop # NOTE: drop "BOS/EOS"
    parser.extract_vowel(parser.romanize(kanas.join))
  end
end
