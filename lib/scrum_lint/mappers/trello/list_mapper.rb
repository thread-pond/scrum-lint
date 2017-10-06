module ScrumLint
  module Trello
    # a mapper class to turn Ruby Trello lists into ScrumLint lists
    class ListMapper

      include Callable

      def call(trello_list, board_name:)
        ScrumLint::List.new(list_params(trello_list)).tap do |list|
          list.cards = mapped_cards(
            list: list,
            trello_list: trello_list,
            board_name: board_name
          )
        end
      end

    private

      def list_params(trello_list)
        { name: trello_list.name }
      end

      def mapped_cards(list:, trello_list:, board_name:)
        trello_list.cards.map do |trello_card|
          card_mapper.(trello_card, list: list, board_name: board_name)
        end
      end

      def card_mapper
        @card_mapper ||= ScrumLint::Trello::CardMapper.new
      end

    end
  end
end
