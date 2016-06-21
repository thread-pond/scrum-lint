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

    end
  end
end
