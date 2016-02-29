module ScrumLint
  # `ScrumLint::Runner` is where it all begins. It sets up configuration, looks
  # up and validates the board, and then runs the lints
  class Runner

    include Callable

    def call
      ScrumLint::Configurator.()
      ScrumLint::Linter::ExtraList.(board)
      ScrumLint::Linter::MissingTaskList.(board)
      ScrumLint::Linter::MissingContext.(board)
    end

  private

    def board
      @board ||= ScrumLint::Board.new(locate_board)
    end

    def locate_board
      matching_boards = boards.select { |board| board.name == board_name }
      raise 'multiple boards match' if matching_boards.size > 1
      matching_boards.first
    end

    def boards
      Trello::Board.all
    end

    def board_name
      ScrumLint.config.board_name
    end

  end
end
