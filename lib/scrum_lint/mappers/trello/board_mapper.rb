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
        lists = mapped_lists(trello_board)
        {
          lists: lists,
          name: trello_board.name,
          url: trello_board.url,
          context: board_context(trello_board, lists: lists),
        }
      end

      def board_context(trello_board, lists:)
        {
          active_project_cards: active_project_cards(lists),
          available_labels: trello_board.labels,
          project_cards: project_cards(lists),
        }
      end

      def active_project_cards(lists)
        lists.select { |list| list.name == 'Active Projects' }.flat_map(&:cards)
      end

      def project_cards(lists)
        lists.flat_map(&:cards).select { |card| card.tags.include?(:project) }
      end

      def mapped_lists(trello_board)
        trello_board.lists.map do |trello_list|
          print '.'
          list_mapper.(trello_list)
        end
      end

      def list_mapper
        @list_mapper ||= ScrumLint::Trello::ListMapper.new
      end

    end
  end
end
