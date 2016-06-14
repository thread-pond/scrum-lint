module ScrumLint
  module Trello
    # a mapper class to query Trello via Ruby Trello and return a
    # mapped tree of ScrumLint models
    class Mapper

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
          trello_board.name == board_name
        end
      end

      def board_name
        ScrumLint.config.board_name
      end

    end
  end
end
