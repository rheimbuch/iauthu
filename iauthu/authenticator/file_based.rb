module IAuthU
  module Authenticator
    class FileBased < Base
      def initialize(file)
        @file = file
      end
      
      attr_accessor :default_cred
      
      
      
      private
      def file(&block)
        File.open(@file, &block)
      end
      
      def auth(user,pass)
        lines = []
        file do |f|
          lines = f.readlines
        end
        
      end
    end
  end
end