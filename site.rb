require File.join(File.dirname(__FILE__), 'request')
module IAuthU
  
=begin rdoc
  IAuthU::Site represents your remote ITunesU site. 
  
    site = IAuthU::Site.build {
      url "https://deimos.apple.com/WebObjects/Core.woa/Browse/montana.edu"
      debug_suffix "/aqc392"
      shared_secret "WQBMFYFFH7SBPVFXMCEBG43WC2ANW7LQ"
      cred :admin, "Administrator\@urn:mace:itunesu.com:sites:montana.edu"
      cred :user, "Authenticated\@urn:mace:itunesu.com:sites:montana.edu"
    }
=end
  class Site
    def self.build(&block)
      builder = Builder.new
      builder.instance_eval(&block)
      builder.site
    end
    
    def initialize(opts={})
      @debug = false
      opts = {:url => "", :debug_suffix => "", :shared_secret => "", :credentials => {}}.merge(opts)
      opts.keys.each{|var| instance_variable_set "@#{var.to_s}", opts[var]}
    end
    attr_accessor :url, :debug_suffix, :debug, :shared_secret, :credentials
    
    
    
    def authentication_request(user)
      user = user.clone
      creds = user.delete("credentials") || []
      tmp = []
      creds.each{|c| tmp << credentials[c]}
      
      req = Request.new(user, tmp, self)
      req.debug = debug
      req
    end
    
    class Builder # :nodoc:
      def initialize
        @site = Site.new
      end
      
      attr_reader :site
      
      def url(url)
        @site.url = url
      end
      
      def debug_suffix(suffix)
        @site.debug_suffix = suffix
      end
      
      def debug(bool=true)
        @site.debug = bool
      end
      
      def shared_secret(str)
        @site.shared_secret = str
      end
      
      def cred(name, credential)
        name = name.to_sym
        @site.credentials[name] = credential.to_s
      end
    end
  end
end