#!/usr/bin/ruby
require "rubygems"
gem "git"
require "git"
require "logger"

working_dir = "/home/svk/development/pa"

git = Git::Base.open(working_dir, :log => Logger.new(STDOUT))

git.branches.local.each do |branch|
  puts branch.name
end
