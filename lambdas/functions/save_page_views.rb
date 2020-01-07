require 'json'
require 'net/http'
require 'uri'

def exec(event:, context:)
  auth_user = ENV['BATCH_USERNAME']
  auth_pass = ENV['BATCH_PASSWORD']
  
  url = URI.parse("#{ENV['BATCH_HOSTNAME']}/batch/save_page_views")
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
  req = Net::HTTP::Post.new(url.path)
  req.basic_auth(auth_user, auth_pass)
  res = http.request(req)
  
  if res.is_a? Net::HTTPSuccess
    puts "{ statusCode: 200 }"
  else
    puts "{ statusCode: 422 }"
    puts res.body
  end
end
