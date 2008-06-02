require 'rubygems'
require 'net/http'
require 'net/https'
require 'hmac-sha2'
require 'cgi'

module IAuthU
  
=begin rdoc
  IAuthU::Request performs the ITunesU authentication step. Usually you will
  not create a Request object manually, but will instead recieve it from
  a Site object. A Request object defers the actual connection to ITunesU
  until the #call method is invoked. 
=end
  class Request
    def initialize(user, creds, site)
      @user = user
      @creds = creds.to_a
      raise MissingCredentialsError, "Credentials cannot be empty." if @creds.empty?
      @site = site
      @debug = false
    end
    
    attr_accessor :debug
    
    def call
      token, data = get_authorization_token(@user, @creds, @site.shared_secret)
      invoke_action(site_url, data, token)
    end
    
    class MissingCredentialsError < RuntimeError; end
    
    private
    
    def site_url
      debug ? "#{@site.url}#{@site.debug_suffix}" : @site.url 
    end
    
    def identity_string(identity)
      display_name = identity["display_name"]
      email_address = identity["email"]
      username = identity["username"]
      user_identifier = identity["identifier"]
      "\"#{display_name}\" <#{email_address}> (#{username}) [#{user_identifier}]"
    end
    
    def get_authorization_token(identity, credentials, key)
      identity = identity_string(identity)
      credentials = credentials * ';'
      token = {}
      expiration = Time.new().to_i
      
      #Need to escape using CGI.escape; URI.escape doesn't escape '()<>' properly
      cred = CGI.escape(credentials)
      id = CGI.escape(identity)
      exp = CGI.escape(expiration.to_s)

      buffer = "credentials=#{cred}&identity=#{id}&time=#{exp}"
      
      sig = HMAC::SHA256.new(key)
      sig << buffer
      buffer = buffer + "&signature=#{sig}"

      token = {
        'credentials' => credentials,
        'identity' => identity,
        'time' => expiration.to_s,
        'signature' => sig.to_s
      }

      return token, buffer
    end
    
    def invoke_action(site_url, data, token_hdrs)
      uri = URI.parse(site_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      puts token_hdrs.inspect
      response = http.request_post(uri.path, data, token_hdrs)
      return response
    end
  end
end