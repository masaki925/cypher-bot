desc 'battle'
task :battle, [:text] => :environment do |_t, args|
  rg = RhymeGenerator.new(args['text'])
  puts "----\n" + rg.get_rhyme
end

