module ScrumLint
  module Linter
    # Checks a board for lists that are not matched by any selectors
    class ExtraList

      include Callable

      def call(board)
        extra_list_names = all_list_names(board) - expected_list_names(board)
        warn "extra lists found: #{extra_list_names}" if extra_list_names.any?
      end

    private

      def all_list_names(board)
        board.list_names
      end

      def expected_list_names(board)
        ScrumLint.config.project_list_names +
          ScrumLint.config.task_list_names +
          board.done_lists.map(&:name) +
          ScrumLint.config.ignored_list_names
      end

    end
  end
end
