require "./utils"
require "./pwned"

enum CommandName
  Pwned
  Generate
end

abstract class SubCommand
  abstract def execute
end

class Command
  property sub_command : SubCommand = DummyCommand.new

  def execute
    sub_command.execute
  end
end

class PwnedCommand < SubCommand
  property password = ""
  property show_password = false

  def execute
    if @password.empty?
      prompt = "Enter a password: "
      @password = Utils.getpass(prompt)
    end
    count = Pwned.count(@password)
    if count > 0
      msg = "Password pawned #{count} times."
      if @show_password
          msg = "Password '#{@password}' was pwned #{count} times."
      end
      puts msg.colorize.red.bold.to_s
    else
      msg = "Password not pawned."
      if @show_password
          msg = "Password '#{@password}' was not pwned."
      end
      puts msg.colorize.green.bold.to_s
    end
  end
end

class GenerateCommand < SubCommand
  def execute
    puts "Generate password: not implemented yet"
  end
end

class DummyCommand < SubCommand
  def execute
    puts "Run password --help"
  end
end
