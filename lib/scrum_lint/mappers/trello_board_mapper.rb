module ScrumLint
  # a mapper class to turn Ruby Trello boards into ScrumLint boards
  class TrelloBoardMapper

    include Callable

    def call(trello_board)
      ScrumLint::Board.new(trello_board)
    end

  end
end
