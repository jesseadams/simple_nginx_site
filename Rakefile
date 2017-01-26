require 'rake-foodcritic'
require "cookstyle"
require "rubocop/rake_task"

RuboCop::RakeTask.new do |task|
  task.options << "--display-cop-names"
end

task :build do
  [:chef:foodcritic].each { |t| build t }
end
