module Utils
  extend self

  def getpass(prompt : String) : String
    print prompt
    entry = STDIN.noecho &.gets.try &.chomp
    puts
    if entry.nil?
      return ""
    end
    entry
  end

end
