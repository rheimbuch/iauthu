= IAuthU

* http://github.com/rheimbuch/iauthu

== DESCRIPTION:

IAuthU provides a basic iTunes U authentication server, along with libraries for building iTunes U authentication servers into your own application.

== FEATURES/PROBLEMS:

* Features
  * Support for iTunes U authentication system.
  * Plug-able authentication back-ends.
  * Includes authentication back-ends for basic LDAP and chained authentication sources.
  * Supports running as CGI, FastCGI, WEBrick, Mongrel, etc using Rack

== SYNOPSIS:

* Generate the config file in /etc/iauthu/iauthu.conf (see `iauthu -h` for all options)

    $ sudo iauthu -g

* Edit /etc/iauthu/iauth.conf and fill in your iTunes U authentication settings.

* To run as a standalone server:

    $ iauthu

* To run as a cgi, symlink the iauthu binary into your cgi-bin directory or any directory that allows executing cgi scripts:

    $ ln -s /usr/bin/iauthu /usr/lib/cgi-bin/iauthu.cgi


== REQUIREMENTS:

* Rack
* Markaby
* Ruby-HMAC
* Net/LDAP

== INSTALL:

  gem install iauthu

== LICENSE:

(The MIT License)

Copyright (c) 2008 Ryan Heimbuch

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
