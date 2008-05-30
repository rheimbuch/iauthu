require 'rubygems'
require File.join(File.dirname(__FILE__), 'site')
require File.join(File.dirname(__FILE__), 'authenticator/chained')
require 'rack'
require 'rack/showexceptions'
require 'rack/request'
require 'rack/response'
require 'markaby'


module IAuthU
  class Server
    def self.build(&block)
      b = Builder.new
      b.instance_eval(&block)
      b.server
    end
    
    def initialize
      @runner = Rack::Handler::WEBrick
      @port = 9292
      @login_page = login_form
    end
    attr_accessor :site, :auth, :runner, :port, :login_page
    
    def run
      raise "Site config is required" unless @site
      raise "Auth config is required" unless @auth
      @runner.run(Rack::ShowExceptions.new(Rack::Lint.new(self)), :Port => @port)
    end
    
    def call(env)
      req = Rack::Request.new(env)
      user, pass = req.POST["username"], req.POST["password"]
      # if user && pass
      #         logged_in, result = login(user, pass)
      #       else
      #         logged_in = false
      #       end
      #       result = login_page unless logged_in
      #       res = Rack::Response.new
      #       res.write result
      #       res.finish
      unless req.POST["username"] && req.POST["password"]
        Rack::Response.new.finish do |res|
          res.write login_page
        end
      else
        Rack::Response.new.finish do |res|
          logged_in, result = login(req.POST["username"], req.POST["password"])
          puts result
          res.write result
        end
      end
    end
    
    private
    
    def login(user, pass)
      identity = @auth.call(user,pass)
      if identity
        req = @site.authentication_request(identity)
        resp = req.call
        [:true, resp.body]
      else
        [:false, login_page]
      end
    end
    
    def login_form
      page_title = "iTunesU Login"
      m = Markaby::Builder.new
      m.html do
        head { title page_title}
        body do
          h1 page_title
          form(:method => 'post') do
            p {
              label("Username: ", :for => 'username')
              input(:type => 'text', :name => 'username', :id => 'username')
            }
            p {
              label("Password: ", :for => 'password')
              input(:type => 'password', :name => 'password', :id => 'password')
            }
            input(:type => 'submit', :value => 'Login')
          end
        end
      end
      m.to_s
    end
    
    class Builder
      RUNNERS = { :cgi => Rack::Handler::CGI,
                  :fastcgi => Rack::Handler::FastCGI,
                  :webrick => Rack::Handler::WEBrick,
                  :mongrel => Rack::Handler::Mongrel
        }
        
      def initialize
        @server = Server.new
      end
      
      attr_reader :server
      
      def site(&block)
        @server.site = Site.build(&block)
      end
      
      def auth(&block)
        @server.auth = Authenticator::Chained.build(&block)
      end
      
      def login_page(str_or_file=nil, &block)
        if str_or_file
          if File.exist?(str_or_file)
            File.open(str_or_file) do |f|
              @server.login_page = f.read
            end
          else
            @server.login_page = str_or_file
          end
          return
        else
          @server.login_page = block.call.to_s
        end
      end
      
      def run(type, opts={})
        @server.runner = RUNNERS[type] || RUNNERS[:webrick]
        @server.port ||= opts[:port]
      end
    end
  end
end