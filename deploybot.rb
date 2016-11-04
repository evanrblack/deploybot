require 'net/http'
require 'faker'
require 'json'

TOP_LEVEL = `git rev-parse --show-toplevel`
REPO_NAME = `basename #{TOP_LEVEL}`.strip!
LCD_FILE = "#{File.dirname(__FILE__)}/last_commit_deployed_#{REPO_NAME}"

abort if REPO_NAME.nil? || REPO_NAME == ''

newest_commit = `git log -1 --pretty=%h`.strip
if not File.exist?(LCD_FILE)
  File.open(LCD_FILE, 'w') { |f| f.puts `git log --reverse --pretty=%h | head -1` }
end
last_commit_deployed = File.read(LCD_FILE).strip

abort("LAST COMMIT DEPLOYED IS NEWEST COMMIT") if last_commit_deployed == newest_commit

hashes = `git rev-list #{last_commit_deployed}..#{newest_commit}`.split("\n").map{ |h| h[0..6] }
commits = []
hashes.reverse.each do |hash|
  message = `git log --format=%B -n1 #{hash}`.split("\n").first
  commits << { hash: hash, message: message }
end

def attachmentize(commit)
  formatted = "#{commit[:hash][0..6]}: #{commit[:message]}"
  { fallback: formatted, text: formatted, color: Faker::Color.hex_color }
end

params = { 
  channel: '#development', 
  username: 'deploybot', 
  text: "COMMIT DEPLOYED (#{REPO_NAME.upcase})",
  attachments: commits.map{ |commit| attachmentize(commit) },
  icon_emoji: ':robot_face:' }
json_headers = { 'Content-Type' => 'application/json' }

puts params

uri = URI.parse(ENV['SLACK_DEPLOY_URL'])
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.post(uri, params.to_json, json_headers)

File.open(LCD_FILE, 'w') { |f| f.write(newest_commit) }
