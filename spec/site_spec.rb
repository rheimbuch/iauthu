require File.dirname(__FILE__) + '/spec_helper.rb'
require 'iauthu'

include IAuthU

describe Site do  
  it "should properly set default values" do
    site = Site.new
    site.url.should == ""
    site.debug.should == false
    site.debug_suffix.should == ""
    site.shared_secret.should == ""
    site.credentials.should == {}
  end
  
  it "should set values passed to #new" do
    url = "https://deimos.apple.com/WebObjects/Core.woa/Browse/foo.edu"
    debug_suffix = "/bcv345"
    debug = true
    shared_secret = "FDAFEIJFASKFLAKFSA"
    credentials = {:user => "Authenticated@urn:mace:itunesu.com:sites:foo.edu"}
    
    site = Site.new :url => url, 
                    :debug_suffix => debug_suffix, 
                    :debug => debug, 
                    :shared_secret => shared_secret,
                    :credentials => credentials
    
    site.url.should == url
    site.debug_suffix.should == debug_suffix
    site.debug.should == debug
    site.shared_secret.should == shared_secret
    site.credentials.should == credentials
  end
  
  it "should throw an exception when #authentication_request is called and user credentials are empty" do
    site = Site.new
    site.url = "https://deimos.apple.com/WebObjects/Core.woa/Browse/foo.edu"
    identity = {:username => 'tester'}
    lambda{ 
      site.authentication_request(identity)
    }.should raise_error(Site::MissingCredentialsError, "Credentials entry is missing in: #{identity.inspect}")
  end
  
  it "should throw an exception when #authentication_request is called with an empty site url" do
    site = Site.new
    lambda{ 
      site.authentication_request({:username => 'tester', :credentials => [:user]})
    }.should raise_error(Site::SettingsError, "Site url must be set before sending request.")
  end
end