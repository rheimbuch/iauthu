module IAuthU
  class Credential
    def initialize(*creds)
      @creds = creds || []
    end
    
    def +(cred)
      tmp = @creds + cred.to_a
      Credential.new(tmp)
    end
    
    def to_s
      @creds * ";"
    end
    
    def to_a
      @cred.map{|c| c}
    end
    
    def inspect
      to_a.inspect
    end
  end
end