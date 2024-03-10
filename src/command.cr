require "./utils"
require "./pwned"
require "./generate"

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
      msg = "Password was pawned #{count} times."
      if @show_password
          msg = "Password '#{@password}' was pwned #{count} times."
      end
      puts msg.colorize.red.bold.to_s
    else
      msg = "Password was not pawned."
      if @show_password
          msg = "Password '#{@password}' was not pwned."
      end
      puts msg.colorize.green.bold.to_s
    end
  end
end

class GenerateCommand < SubCommand
  property length = 16

  def execute
    puts Generate.password @length
  end
end

class DummyCommand < SubCommand
  def execute
    puts "Run password --help"
  end
end
