require 'trello'

module ScrumLint
  module Trello
    # a top-level class to query Trello via Ruby Trello and return a
    # mapped tree of ScrumLint models
    class Source

      include Callable

      def call
        trello_boards.map do |trello_board|
          board_mapper.(trello_board)
        end
      end

    private

      def board_mapper
        @board_mapper ||= ScrumLint::Trello::BoardMapper.new
      end

      def trello_boards
        ::Trello::Board.all.select do |trello_board|
          board_names.include?(trello_board.name)
        end
      end

      def board_names
        Set.new(ScrumLint.config.board_names)
      end

    end
  end
end
