require 'rubygems'
require 'rack/request'
require 'rack/response'
require 'markaby'


module IAuthU
  class LoginServer
    def initialize(site, auth)
      @site = site
      @auth = auth
      @page = {:title => "iTunesU Login"}
    end
    
    attr_reader :page
    
    def call(env)
      req = Rack::Request.new(env)
      unless req.POST["username"] && req.POST["password"]
        Rack::Response.new.finish do |res|
          res.write login_form
        end
      else
        Rack::Response.new.finish do |res|
          res.write login(req.POST["username"], req.POST["password"])
        end
      end
    end
    
    def login(user, pass)
      identity = @auth.call(user,pass)
      creds = identity.delete("credentials")
      req = @site.authentication_request(identity, creds)
      resp = req.call
      resp.body
    end
    
    def login_form
      page = @page
      m = Markaby::Builder.new
      m.html do
        head { title page[:title]}
        body do
          h1 page[:title]
          form(:method => 'post') do
            p {
              label("Username", :for => 'username')
              input(:type => 'text', :name => 'username', :id => 'username')
            }
            p {
              label("Password", :for => 'password')
              input(:type => 'password', :name => 'password', :id => 'password')
            }
            input(:type => 'submit', :value => 'Login')
          end
        end
      end
      m.to_s
    end
  end
end