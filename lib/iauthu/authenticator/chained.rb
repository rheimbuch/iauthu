require File.join(File.dirname(__FILE__), 'base')
module IAuthU
  module Authenticator
    
=begin rdoc
  The Chained Authenticator allows multiple authentication objects to 
  be combined. The order in which authenticators are added is the order
  in which they are executed. The identity hash that each authenticator
  returns is combined with the one returned by the previous authenticator.
  
    local_auth = IAuthU::Authenticator::Chained.build {
      #Use builtin htaccess authenticator
      use IAuthU::Authenticator::FileBased.new('/etc/itunesu/user.auth'), :required => true
      
      #Call a custom authenticator
      use CustomLDAPAuth.new
      
      #Add default user credential to all identities
      use lambda {|user,pass| {:credentials => [:user]}} 
    }
=end
    class Chained < Base
      
=begin rdoc
  Allows easy construction of chained authenticators. The format for 
  specifying the authentication chain is:
    use someAuthenticator [, {:required => true|false, :sufficient => true|false}]
=end
      def self.build(&block)
        chained = Builder.new
        chained.instance_eval(&block)
        chained.auth
      end
      
      # Creates a new Chained authentication object. A list of authenticators
      # can be passed. This will create an authentication chain compoased of
      # the passed authenticators.
      def initialize(*args)
        @chain = args || []
      end
      
      # Append an authenticator to the authentication chain.
      def <<(authenticator)
        add authenticator
      end
      
      # Append an authenticator to the authentication chain. Optionally specifiy
      # if the authenticator is required or sufficient for the chain. required and
      # sufficient both default to false.
      #   chain.add MyAuth.new  # MyAuth is not required and not sufficient
      #   chain.add MyAuth.new, :required => true, :sufficient => false
      def add(authenticator, opts={})
        authenticator.required = !!opts["required"] if opts["required"] && authenticator.respond_to?('required=')
        authenticator.sufficient = !!opts["sufficient"] if opts ["sufficient"] && authenticator.respond_to?('sufficient=')
        @chain << authenticator
      end
      
      # Invoke the authentication chain
      def call(username,password)
        auths = @chain.clone
        identity = {}
        until auths.empty?
          auth = auths.shift
          new_ident = auth.call(username,password)
          if new_ident.nil? && auth.respond_to?(:required) && auth.required
            #Authentication failed for a required authenticator
            return nil
          end
          identity = merge_identities(identity, new_ident)
          if identity && auth.respond_to?(:sufficient) && auth.sufficient
            #This authenticator is sufficient; do not continue down auth chain.
            break
          end
        end
        return nil if identity.empty?
        identity
      end
      
      private
      def merge_identities(orig, other)
        ident = {}.merge(orig)
        return ident if other.nil? || other.empty?
        creds = other.delete("credentials") || []
        ident["credentials"] ||= []
        ident["credentials"] << creds
        ident["credentials"].flatten!.uniq!
        
        ident.merge(other)
      end
      
      
      class Builder # :nodoc:
        def initialize
          @auth = Chained.new
        end
        
        attr_reader :auth
        
        def use(authenticator, opts={})
          @auth.add authenticator, opts
        end
      end
    end
  end
end