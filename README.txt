= IAuthU

* http://github.com/rheimbuch/iauthu

== DESCRIPTION:

IAuthU provides a basic framework for building iTunesU authentication servers. 

== FEATURES/PROBLEMS:

* Features
  * Support for iTunesU authentication system.
  * Plug-able authentication back-ends.
  * Includes authentication back-ends for basic LDAP and chained authentication sources.
  * Supports running as CGI, FastCGI, WEBrick, Mongrel, etc using Rack

== SYNOPSIS:

  require 'rubygems'
  require 'iauthu'
  require 'iauthu/authenticator/ldap'

  server = IAuthU::Server.build do
    site {
       url "https://deimos.apple.com/WebObjects/Core.woa/Browse/somewhere.edu"
       debug_suffix "/bcg495"
       # debug
       shared_secret "FDASFEFDASF$T%$FDFASD"
       cred :admin, "Administrator@urn:mace:itunesu.com:sites:somewhere.edu"
       cred :user, "Authenticated@urn:mace:itunesu.com:sites:somewhere.edu"
       }

   auth {
     # Authenticate Users from LDAP
     use IAuthU::Authenticator::LDAP.build {
       servers "ldap.somewhere.edu"
       login_format "uid=%s,ou=People,o=ldap.somewhere.edu,o=cp"
       credentials [:user]
       }

     # Authenticate a custom admin user
     use lambda {|user, pass|
       if user == 'site' && pass == 'admin'
         {"display_name" => "Site Administrator",
           "email" => "support@somewhere.edu",
           "credentials" => [:admin]}
       end
       }
    }

    run :webrick, :port => 9292
  end

  server.run

== REQUIREMENTS:

* Rack
* Markaby
* Ruby-HMAC
* Net/LDAP

== INSTALL:

  gem install iauthu

== LICENSE:

(The MIT License)

Copyright (c) 2008 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
