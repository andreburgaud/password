require "digest/sha1"
require "http/client"

module Pwned
  extend self
  PWNED_URL = "https://api.pwnedpasswords.com/range"

  def count(password : String) : Int
    hash = Digest::SHA1.new().update(password).hexfinal.upcase
    prefix = hash[0, 5]

    response = HTTP::Client.get "#{PWNED_URL}/#{prefix}"

    response.body.lines.each do |line|
      suffix, count = line.split(":")
      if "#{prefix}#{suffix}" == hash
          return count.to_i
      end
    end
    0
  end
end
