class RhymeGenerator2
  require 'fileutils'

  @@rhyme_model_file = Rails.root.join('app', 'assets', 'ml_models', 'rhyme.model')

  def initialize(user_text, session_id)
    @user_text = user_text
    FileUtils.mkdir_p(Rails.root.join('tmp', 'svm_rank', session_id))
    @candidate_score_file = Rails.root.join('tmp', 'svm_rank', session_id, 'candidate_score.dat')
    @rank_score_file      = Rails.root.join('tmp', 'svm_rank', session_id, 'rank_score.dat')
  end

  def get_rhyme
    calc_candidate_scores
    rank_candidates
    RHYME_CANDIDATES[top_rank_idx]
  end

  private

  def vowelize(term)
    "aaeaiaoei"
  end

=begin
  def end_rhyme_score(cand_text)
    vowels_user_text = vowelize(@user_text)
    vowels_cand_text = vowelize(cand_text)

    comp_len = [vowels_user_text.size, vowels_cand_text.size].min

    sub_vowels_user_text = vowels_user_text.split(//).last(comp_len).join
    sub_vowels_cand_text = vowels_cand_text.split(//).last(comp_len).join

    cnt = 0

    comp_len.times do |n|
      cnt += 1 if sub_vowels_user_text[n] == sub_vowels_cand_text[n]
    end

    cnt
  end
=end

  def calc_candidate_scores
    records = []

    RHYME_CANDIDATES.each_with_index do |cand, idx|
      records << "#{idx} qid:1 1:#{RhymeEvaluator.new.length_score(@user_text, cand)}"
    end

    open(@candidate_score_file, 'w') do |f|
      records.each do |r|
        f.puts(r)
      end
    end
  end

  def rank_candidates
    `svm_rank_classify #{@candidate_score_file} #{@@rhyme_model_file} #{@rank_score_file}`
  end

  def top_rank_idx
    rank_scores = File.readlines(@rank_score_file).map {|n| n.to_f}
    rank_scores.rindex(rank_scores.min)
  end
end
