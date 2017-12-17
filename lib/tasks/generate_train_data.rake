desc 'generate train data'
task :generate_train_data, [:lyrics_path] => :environment do |_t, args|
  file_names = Dir.glob("#{args['lyrics_path']}/*")

  train_data = []
  g_idx = 0

  file_names.each do |file_name|
    open(file_name, 'r') do |f|
      text = f.read()
      terms = text.split(/[\n　]/)
      terms.delete("")
      terms.each_with_index do |term, idx|
        break if idx == terms.size - 1

        # 正解
        end_rhyme_score = RhymeEvaluator.end_rhyme_score(terms[idx], terms[idx + 1])
        length_score    = RhymeEvaluator.length_score(terms[idx], terms[idx + 1])
        train_data.push("1 qid:#{g_idx} 1:#{end_rhyme_score} 2:#{length_score}")

        while(1) do
          rand_idx = rand(terms.size)
          break if rand_idx != idx + 1
        end

        # ランダム
        end_rhyme_score = RhymeEvaluator.end_rhyme_score(terms[idx], terms[rand_idx])
        length_score    = RhymeEvaluator.length_score(terms[idx], terms[rand_idx])
        train_data.push("2 qid:#{g_idx} 1:#{end_rhyme_score} 2:#{length_score}")

        g_idx += 1
      end
    end
  end

  out_file = Rails.root.join('tmp', 'svm_rank_train', 'train.dat')

  open(out_file, "w") do |f|
    train_data.each do |td|
      f.puts(td)
    end
  end
end

