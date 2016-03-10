module ScrumLint
  # `ScrumLint::Runner` is where it all begins. It sets up configuration, looks
  # up and validates the board, and then runs the lints
  class Runner

    include Callable

    LINTERS = {
      board: {
        all: [
          Linter::ExtraList,
          Linter::MissingTaskList,
          Linter::MissingContext,
        ],
      },
      list: { all: [] },
      card: { all: [] },
    }.freeze

    def call
      ScrumLint::Configurator.()
      boards.each do |board|
        run_board_lints(board)
      end
    end

  private

    def run_board_lints(board)
      fetch_linters(board).each do |linter|
        linter.(board)
      end
      board.lists.each do |list|
        run_list_lints(list)
      end
    end

    def run_list_lints(list)
      fetch_linters(list).each do |linter|
        linter.(list)
      end
      list.cards.each do |card|
        run_card_lints(card)
      end
    end

    def run_card_lints(card)
      fetch_linters(card).each do |linter|
        linter.(card)
      end
    end

    def fetch_linters(entity)
      entity_linters = LINTERS[entity.to_sym]
      entity_linters.values_at(*entity.tags).flatten.uniq
    end

    def boards
      [board]
    end

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
