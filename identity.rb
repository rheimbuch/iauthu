module IAuthU
  class Identity
    def initialize(display_name, email, username, identifier)
      @display_name = display_name
      @email = email
      @username = username
      @identifier = identifier
    end
    
    attr_accessor :display_name, :email, :username, :identifier
    
    def to_s
      "\"#{display_name}\" <#{email_address}> (#{username}) [#{identifier}]"
    end
  end
end