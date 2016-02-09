require 'trello'
require 'colorize'
require 'byebug'

require_relative 'trello_pure/configurator'
require_relative 'trello_pure/configuration'
require_relative 'trello_pure/board_validator'
require_relative 'trello_pure/models/board'
require_relative 'trello_pure/checkers/context_checker'

class TrelloPure

  def self.call
    new.()
  end

  def call
    TrelloPure::Configurator.()
    TrelloPure::BoardValidator.(board)
    TrelloPure::ContextChecker.(board)
  end

  def self.config
    @config ||= TrelloPure::Configuration.new
  end

private

  def list_cards_without_context
  end

  def board
    @board ||= TrelloPure::Board.new(locate_board)
  end

  def locate_board
    matching_boards = boards.select { |board| board.name == board_name }
    fail 'multiple boards match' if matching_boards.size > 1
    matching_boards.first
  end

  def boards
    Trello::Board.all
  end

  def board_name
    TrelloPure.config.board_name
  end

end
