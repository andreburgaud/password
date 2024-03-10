require "random/secure"

module Generate
  extend self

  LOWER = "abcdefghijklmnopqrstuvwxyz"
  UPPER = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  DIGITS = "0123456789"
  PUNCTUATION = "!@#$%^&*(-_=+)"

  class Secret
    include Iterator(String)

    def initialize(@length : Int32, alphabet : String)
      @produced = 0
      @alphabet = alphabet.chars.shuffle(Random::Secure)
      @max = @alphabet.size
    end

    def next
      if @produced < @length
        @produced += 1
        @alphabet[Random::Secure.rand(@max)]
      else
        stop
      end
    end
  end

  def password(size : Int32) : String
    alphabet = LOWER + UPPER + DIGITS + PUNCTUATION
    secret = Secret.new(size, alphabet)
    password = Array(Char).new

    while !(elem = secret.next).is_a?(Iterator::Stop)
        password << elem
    end
    password.join("")
  end

end
