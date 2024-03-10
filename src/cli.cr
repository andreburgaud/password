require "colorize"
require "option_parser"
require "./command"

BANNER =
" ______                                           __
|   __ \\.---.-.-----.-----.--.--.--.-----.----.--|  |
|    __/|  _  |__ --|__ --|  |  |  |  _  |   _|  _  |
|___|   |___._|_____|_____|________|_____|__| |_____|
"
VERSION = "0.2.0"
APP = "password"

class Cli

  @args_missing = true

  def help(parser : OptionParser)
    STDERR.puts BANNER.colorize.green.bold.to_s
    STDERR.puts "#{"Description:".colorize.yellow.bold} Password provides a set of tools to operate on secrets.\n"
    STDERR.puts parser
    STDERR.puts "\nTo show a command help, execute #{"password <command> --help".colorize.yellow.bold}.\n"
  end

  def parse : Command
    unless ARGV.empty?
      @args_missing = false
    end

    cmd = Command.new

    parser = OptionParser.new do |parser|
      parser.banner = "#{"Usage:".colorize.yellow.bold} #{APP} <command> [options]"

      # pwned sub_command
      parser.on CommandName::Pwned.to_s.downcase, "Check passwords against previous data breaches.".colorize.white.bold.to_s do
        sub_command = PwnedCommand.new
        parser.banner = "#{"Usage:".colorize.yellow.bold} #{APP} pwned [options] [arguments]"
        parser.on "-p SECRET", "--password=SECRET", "Password to check.".colorize.white.bold.to_s do |secret|
          unless secret.nil?
            sub_command.password = secret
          end
        end
        parser.on "-s", "--show", "Show password.".colorize.white.bold.to_s do
          sub_command.show_password = true
        end
        cmd.sub_command = sub_command
      end

      # generate sub_command
      parser.on CommandName::Generate.to_s.downcase, "Generate a random password.".colorize.white.bold.to_s do
        sub_command = GenerateCommand.new
        parser.banner = "#{"Usage:".colorize.yellow.bold} #{APP} generate"
        parser.on "-l LENGTH", "--length=LENGTH", "Length of the password to generate.".colorize.white.bold.to_s do |length|
          unless length.nil?
            begin
              sub_command.length = length.to_i
            rescue
              STDERR.puts "The length of the password is expected to be an integer, got '#{length}'".colorize.red.bold.to_s
              exit 1
            end
          end
        end
        cmd.sub_command = sub_command
      end

      # Top options
      parser.on "-v", "--version", "Show version.".colorize.white.bold.to_s do
        puts "#{APP} version #{VERSION}".colorize.green.bold.to_s
        exit
      end
      parser.on "-h", "--help", "Show help.".colorize.white.bold.to_s do
        help(parser)
        exit
      end
      parser.missing_option do |flag|
        STDERR.puts "#{flag} requires a parameter.".colorize.red.bold.to_s
        help(parser)
        exit 1
      end
      parser.invalid_option do |flag|
        STDERR.puts "#{flag} is not a valid option.".colorize.red.bold.to_s
        help(parser)
        exit 1
      end

    end
    parser.parse

    # No arguments were given at the command line (would result in dummy command)
    if @args_missing
      STDERR.puts "Command or options required.".colorize.red.bold.to_s
      help(parser)
      exit 1
    end

    # Arguments or options other than the expected ones (subcommands)
    unless ARGV.empty?
      begin
        CommandName.parse(ARGV[0])
      rescue
        STDERR.puts "'#{ARGV[0]}' was not expected.".colorize.red.bold.to_s
        help(parser)
        exit 1
      end
    end
    cmd
  end

end