desc 'generate rhyme candidates'
task :generate_rhyme_candidates, [:lyrics_path] => :environment do |_t, args|
  lyric_files = Dir.glob("#{args['lyrics_path']}/*")
  out_file    = Rails.root.join('config', 'initializers', 'rhyme_candidates.rb')

  all_terms = []

  lyric_files.each do |lyric_file|
    open(lyric_file, 'r') do |lyric_f|
      text = lyric_f.read()
      terms = text.split(/[\n　]/)
      terms.delete("")
      all_terms.concat(terms)
    end
  end

  open(out_file, 'w') do |out_f|
    out_f.puts('RHYME_CANDIDATES = [')
    all_terms.shuffle.each do |term|
      out_f.puts("'" + term + "',")
    end
    out_f.puts(']')
  end
end

