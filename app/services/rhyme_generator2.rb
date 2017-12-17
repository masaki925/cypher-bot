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

  def calc_candidate_scores
    records = []

    RHYME_CANDIDATES.each_with_index do |cand, idx|
      end_rhyme_score = RhymeEvaluator.end_rhyme_score(@user_text, cand)
      length_score    = RhymeEvaluator.length_score(@user_text, cand)
      records << "#{idx} qid:1 1:#{end_rhyme_score} 2:#{length_score}"
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
