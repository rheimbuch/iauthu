$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'iauthu/server'
require 'logger'
module IAuthU
  VERSION = '0.0.1'
  CONFIG = {:logger => Logger.new(STDERR)}
end