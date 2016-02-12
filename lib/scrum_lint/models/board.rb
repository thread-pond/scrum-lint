require_relative 'list'

module ScrumLint

  class Board
    attr_accessor :trello_board

    def initialize(trello_board)
      self.trello_board = trello_board
    end

    def lists
      @lists ||= trello_board.lists.map { |list| ScrumLint::List.new(list) }
    end

    def done_lists
      @done_lists ||= lists.select { |list| done_list_name?(list.name) }
    end

    def task_lists
      @task_lists ||= lists.select { |list| task_list_name?(list.name) }
    end

  private

    def task_list_name?(name)
      ScrumLint.config.task_list_names.include?(name) # || done_list_name?(name)
    end

    def done_list_name?(name)
      name.match(ScrumLint.config.done_list_matcher)
    end
  end

end
