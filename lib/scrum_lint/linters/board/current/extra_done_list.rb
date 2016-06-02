module ScrumLint
  module Linter
    # Checks a board for more than 6 historical done lists
    class ExtraDoneList

      include Callable

      def call(board)
        return unless too_many_done_lists?(board)

        Launchy.open(board.url)
        puts "board #{board.name.color(:blue)} has too many done lists"
      end

    private

      def too_many_done_lists?(board)
        board.list_names.grep(/^Done/).size > 6
      end

    end
  end
end
