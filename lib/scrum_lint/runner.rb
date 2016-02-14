require_relative 'configurator'
require_relative 'models/board'
require_relative 'board_validator'
require_relative 'checkers/context_checker'

module ScrumLint
  # `ScrumLint::Runner` is where it all begins. It sets up configuration, looks
  # up and validates the board, and then runs the lints
  class Runner

    def self.call
      new.()
    end

    def call
      ScrumLint::Configurator.()
      ScrumLint::BoardValidator.(board)
      ScrumLint::ContextChecker.(board)
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
