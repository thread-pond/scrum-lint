module ScrumLint
  module Reporters
    # interactive reporter that gets input from user
    class InteractiveReporter

      def fail(entity, message)
        puts "#{entity.class_name} #{message}: #{entity.name.color(:green)}"
      end

      def get_value
        print 'enter value > '
        value = gets
        value = value.strip if value
        case value
        when ''
          puts 'skipping lint'
        when nil, 'exit', 'quit'
          goodbye
        else
          yield(value)
        end
      end

    private

      def goodbye
        puts
        puts 'goodbye'
        exit
      end

    end
  end
end
