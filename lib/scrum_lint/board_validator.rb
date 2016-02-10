class ScrumLint

  class BoardValidator
    def self.call(board)
      new.(board)
    end

    def call(board)
      fail "no task lists found!" unless board.task_lists.any?
      extra_list_names = board.lists.map(&:name) - expected_list_names(board)
      warn "extra lists found: #{extra_list_names}" if extra_list_names.any?
    end

  private

    def expected_list_names(board)
      ScrumLint.config.project_list_names +
        ScrumLint.config.task_list_names +
        board.done_lists.map(&:name) +
        ScrumLint.config.ignored_list_names
    end
  end

end
