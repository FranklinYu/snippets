#!/usr/bin/ruby

# Ruby 2.0.0 or above

# # Gemfile
# gem 'nokogiri'

# # .secret.yml
# uid: (user ID)
# secure_pass: (value of cookie "c_secure_pass")

require 'net/http'
require 'base64'
require 'nokogiri'
require 'yaml'

def read_configuration
  conf = {}
  filename = if ARGV[0].nil? then '.secret.yml' else ARGV[0] end
  begin
    File.open(filename, 'r') do |file|
      conf = YAML.load(file)
    end
  rescue Errno::ENOENT
    raise 'configuration file not found'
  end
  raise 'bad configuration file' if conf['secure_pass'].nil? or conf['uid'].nil?
  {
    c_secure_pass: conf['secure_pass'],
    c_secure_login: URI.encode( Base64.strict_encode64('nope'), '='),
    c_secure_uid: URI.encode( Base64.strict_encode64(conf['uid'].to_i.to_s), '=')
  }
end

COOKIES = read_configuration

def uri_with_query(query)
  URI::HTTPS.build(
    scheme: 'https',
    host: 'pt.sjtu.edu.cn',
    port: 443,
    path: '/messages.php',
    query: query
  )
end

class BadResponseError < RuntimeError
  @response

  def initialize(response)
    @response = response
    str = 'Bad HTTP response; check your network.'
    str << " Network info: #{@response.inspect}"
    super str
  end
end

def cookies_str(hash)
  hash.to_a.collect{ |arr| arr.join '=' }.join '; '
end

class URI::Generic
  def path_with_query
    if query.nil?
      path
    else
      path + '?' + query
    end
  end
end

def delete_message(message, http)
  href = URI message['href']
  message_id = URI::decode_www_form( href.query ).assoc('id')[1]
  query = URI.encode_www_form action: 'deletemessage', id: message_id
  uri = uri_with_query query
  puts "removing message #{message_id}"
  response = http.get uri.path_with_query, 'Cookie' => cookies_str(COOKIES)
  raise BadResponseError.new(response) unless response.code.to_i == 302
end

def clear_one_page
  query = URI.encode_www_form(
    action: 'viewmailbox',
    keyword: '咱@您了~',
    place: 'title',
    box: 1,
    unread: 'no'
  )

  uri = uri_with_query query
  Net::HTTP.start( uri.host, uri.port, use_ssl: true ) do |http|
    response = http.get uri.path_with_query, 'Cookie' => cookies_str(COOKIES)
    raise BadResponseError.new(response) unless response.code.to_i == 200

    doc = Nokogiri::HTML response.body
    messages = doc.xpath "//td/a[text()='咱@您了~']"
    messages.each { |message| delete_message(message, http) }
  end
end

clear_one_page
