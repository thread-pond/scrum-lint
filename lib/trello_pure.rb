require 'trello'
require_relative 'trello_pure/board_validator'
require_relative 'trello_pure/board'
require 'colorize'
require 'byebug'

class TrelloPure

  def self.call
    new.()
  end

  def call
    configure!
    TrelloPure::BoardValidator.new.(board)
    list_cards_without_context
  end

  def self.config
    OpenStruct.new(
      board_name: 'Eng: Current',
      task_list_names: ['Planned', 'This week', 'Doing', 'In Review'],
      done_list_matcher: /^Done.*$/,
      project_list_names: ['Active Projects'],
      ignored_list_names: %w(Emergent),
      trello_developer_public_key: ENV.fetch('TRELLO_DEVELOPER_PUBLIC_KEY'),
      trello_member_token: ENV.fetch('TRELLO_MEMBER_TOKEN'),
    )
  end

private

  def list_cards_without_context
    board.task_lists.each do |list|
      cards = cards_without_context(list)
      if cards.any?
        puts "List #{list.name.green} has cards missing context:"
        cards.each { |card| puts "-> #{card.name.blue}" }
      end
    end
  end

  def cards_without_context(list)
    list.cards.select { |card| !card.desc.match(/^Context:/) }
  end

  def configure!
    Trello.configure do |trello_config|
      trello_config.developer_public_key = trello_developer_public_key
      trello_config.member_token = trello_member_token
    end
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

  def trello_developer_public_key
    TrelloPure.config.trello_developer_public_key
  end

  def trello_member_token
    TrelloPure.config.trello_member_token
  end

end
