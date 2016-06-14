module ScrumLint
  module Trello
    # a mapper class to turn Ruby Trello boards into ScrumLint boards
    class BoardMapper

      include Callable

      def call(trello_board)
        ScrumLint::Board.new(board_params(trello_board))
      end

    private

      def board_params(trello_board)
        {
          lists: mapped_lists(trello_board),
          name: trello_board.name,
          url: trello_board.url,
        }
      end

      def mapped_lists(trello_board)
        trello_board.lists.map { |trello_list| list_mapper.(trello_list) }
      end

      def list_mapper
        @list_mapper ||= ScrumLint::Trello::ListMapper.new
      end

    end
  end
end
