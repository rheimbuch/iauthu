module IAuthU
  module Authenticator # :nodoc:
    
=begin rdoc
  IAuthU uses 'Authentication' objects to validate and authenticate users.
  Any object can be used for authentication as long as it follows the following
  conventions:
  - has a #call method that accepts a username and password
  - the #call method returns an identity hash in the form:
      { :username => 'john.doe',
        :display_name => 'John Doe',
        :email => 'john.doe@montana.edu',
        :identifier => '',
        :credentials => [:admin, :user] }
  - the identity hash MUST contain a :username entry
  - if authentication fails the #call method should return nil
  
  This convention allows the use of lambda objects as authenticators:
      lambda {|user,pass| 
        if user == 'foo'
          {:username => user, :credentials => [:admin]}
        end 
      }
  
  There are also optional behavior methods that authentication objects 
  should, but are not required to implement:
  #required::     specifies that an authentication object is required. In an
                  authentication chain, failure of authenticator objects that are required
                  causes the entire chain to fail.
  #sufficient::   specifies that an authentication object is sufficient for
                  authentication. In an auth chain, authenticator objects that are sufficient
                  and successfully authenticate halt the execution of the chain and cause the
                  chain to return a successful authentication.
  
  If you require custom authentication, subclass IAuthU::Authenticator::Base
  and override #call to perform your custom authentication. You may also use
  any object that implements #call as specified above. If you require multiple
  authentication steps, you may compose authenticators together using 
  IAuthU::Authenticator::Chained.
=end
    class Base
      def call(username, password)
        nil
      end
      
      def required
        @required ||= false
      end
      
      def required=(bool)
        @required = !!bool
      end
      
      def sufficient
        @sufficient ||= false
      end
      
      def sufficient=(bool)
        @sufficient = !!bool
      end
    end
  end
end