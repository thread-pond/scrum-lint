module ScrumLint
  # a mapper class to turn Ruby Trello boards into ScrumLint boards
  class TrelloBoardMapper

    include Callable

    def call(trello_board)
      ScrumLint::Board.new(board_params(trello_board))
    end

  private

    def board_params(trello_board)
      {
        lists: mapped_lists(trello_board),
        url: trello_board.url,
        name: trello_board.name,
      }
    end

    def mapped_lists(trello_board)
      trello_board.lists.map { |list| ScrumLint::List.new(list) }
    end

  end
end
