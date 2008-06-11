require 'rubygems'
require 'net/ldap'

module IAuthU
  module Authenticator # :nodoc:
    class LDAP
      def self.build(&block)
        b = Builder.new
        b.instance_eval(&block)
        b.ldap_auth
      end
      
      def initialize(opts)
        @config = opts
        @login_format = @config.delete(:login_format) || "%s"
        @credentials = @config.delete(:credentials) || []
        use_ssl = @config.delete(:use_ssl) || false
        server_names = @config.delete(:servers) || []
        
        @servers = server_names.map do |name|
          conf = @config.clone
          conf[:host] = name
          server = Net::LDAP.new(conf)
          server.encryption(:simple_tls) if use_ssl
          server
        end
      end
      
      def call(user,pass)
        @servers.each do |s|
          s.auth(@login_format % user, pass)
          ident = {"username" => user}
          ident["credentials"] = @credentials
          return ident if s.bind
        end
        return nil
      end
      
      private
      class Builder
        def initialize
          @config = {}
        end
        
        def servers(*svrs)
          @config[:servers] = svrs
        end
        
        def port(num)
          @config[:port] = num
        end
        
        def base(str)
          @config[:base] = str
        end
        
        def login_format(str)
          @config[:login_format] = str
        end
        
        def use_ssl(bool=true)
          @config[:use_ssl]
        end
        
        def config
          @config
        end
        
        def credentials(creds)
          @config[:credentials] = creds.to_a
        end
        
        def ldap_auth
          LDAP.new(config)
        end
      end
    end
  end
end