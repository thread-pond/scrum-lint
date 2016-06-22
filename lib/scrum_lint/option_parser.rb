require 'optparse'

module ScrumLint
  # wrapper around ruby OptionParser
  class OptionParser

    include Callable

    def call(args)
      options = {}
      ::OptionParser.new do |opts|
        opts.banner = 'Usage: scrum-lint [options]'
        opts.on('-i', '--interactive', 'run in interactive mode') do
          options[:interactive] = true
        end
        opts.on('-h', '--help', 'prints this help') do
          puts opts
          exit
        end
      end.parse!(args)
      options
    end

  end
end
