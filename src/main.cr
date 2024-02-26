require "./cli"

cli = Cli.new
cmd = cli.parse
cmd.execute
