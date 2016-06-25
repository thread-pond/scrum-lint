module ScrumLint
  module InteractiveLinter
    # base class for common interactive linter functionality
    class Base

      include Callable

    private

      def goodbye
        puts
        puts 'goodbye'
        exit
      end

      def print_indexed(collection, property)
        collection.each_with_index.map do |item, index|
          puts "#{index + 1}. #{item.public_send(property)}"
        end
      end

    end
  end
end
