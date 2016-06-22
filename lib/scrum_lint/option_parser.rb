require 'optparse'

module ScrumLint
  # wrapper around ruby OptionParser
  class OptionParser

    include Callable

    def call(args)
      options = {}
      ::OptionParser.new do |parser|
        parser.banner = 'Usage: scrum-lint [options]'
        parser.on('-i', '--interactive', 'run in interactive mode') do
          options[:interactive] = true
        end
        parser.on('-h', '--help', 'prints this help') do
          puts parser
          exit
        end
      end.parse!(args)
      options
    end

  end
end
