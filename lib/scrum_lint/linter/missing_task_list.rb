module ScrumLint
  module Linter
    # Checks a board to make sure it has at least one task list
    class MissingTaskList

      include Callable

      def call(board)
        raise 'no task lists found!' unless board.task_lists.any?
      end

    end
  end
end
