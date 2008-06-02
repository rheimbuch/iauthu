# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/iauthu.rb'

Dir['tasks/**/*.rake'].each { |rake| load rake }

Hoe.new('IAuthU', IAuthU::VERSION) do |p|
  p.rubyforge_name = 'IAuthUx' # if different than lowercase project name
  p.developer('Ryan Heimbuch', 'rheimbuch@gmail.com')
  p.extra_deps << ['rack', '>=0.3.0']
  p.extra_deps << ['markaby', '>=0.5']
  p.extra_deps << ['ruby-hmac', '>=0.3.1']
  p.extra_deps << ['ruby-net-ldap', '>=0.0.4']
end

# vim: syntax=Ruby
