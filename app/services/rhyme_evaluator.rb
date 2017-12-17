class RhymeEvaluator
  def length_score(str1, str2)
    max      = [str1.size, str2.size].max
    abs_diff = (str1.size - str2.size).abs
    1.0 - (abs_diff.to_f / max.to_f)
  end

  def end_rhyme_store(str1, str2)
  end
end
