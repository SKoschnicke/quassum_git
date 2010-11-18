require 'rubygems'
require 'mechanize'
require 'hpricot'

require 'config.rb'

page_number = 1

branches = Array.new
File.open("branches.txt").each do |line|
  match = line.match(/ *origin\/(\d+)_(.*)/)
  if match
    number = match[1]
    branch = "#{number}_#{match[2]}"
    branches << {:number => number, :name => branch}
  end
end

quassum_url = "http://#{QUASSUM_COMPANY}.quassum.com"
agent = Mechanize.new
agent.user_agent_alias = "Mac Safari"
page = agent.get("#{quassum_url}/login")
login_form = page.forms.first

login_form["user[email]"] = QUASSUM_USER
login_form["user[password]"] = QUASSUM_PASSWORD
page = login_form.click_button

#File.open("tmp/page_#{page_number}.html", "w") { |f| f.write(page.body) }; page_number += 1;
closed_branches = Array.new

branches.each do |branch|
  page = agent.get("#{quassum_url}/projects/#{QUASSUM_PROJECT_SLUG}/tickets/#{branch[:number]}")

  #File.open("tmp/page_#{page_number}.html", "w") { |f| f.write(page.body) }; page_number += 1;

  status = page.forms.first["ticket[status]"]
  if status == "open"
    puts "Branch #{branch[:name]} is open"
  else
    puts "Branch #{branch[:name]} may be deleted"
    closed_branches << branch
  end

end

page = agent.get("#{quassum_url}/logout")
#File.open("tmp/page_#{page_number}.html", "w") { |f| f.write(page.body) }; page_number += 1;
