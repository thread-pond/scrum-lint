module ScrumLint
  # a mapper class to query Trello via Ruby Trello and return a
  # mapped tree of ScrumLint models
  class TrelloMapper

    include Callable
    
    def call
      [board]
    end

  private

    def board
      @board ||= ScrumLint::Board.new(locate_board)
    end

    def locate_board
      matching_boards = trello_boards.select do |board|
        board.name == board_name
      end
      raise 'multiple boards match' if matching_boards.size > 1
      matching_boards.first
    end

    def trello_boards
      Trello::Board.all
    end

    def board_name
      ScrumLint.config.board_name
    end

  end
end
