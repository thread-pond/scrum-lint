module ScrumLint
  module Trello
    # a mapper class to turn Ruby Trello cards into ScrumLint cards
    class CardMapper

      include Callable

      def call(trello_card, list:)
        ScrumLint::Card.new(card_params(trello_card, list: list))
      end

    private

      def card_params(trello_card, list:)
        {
          desc: trello_card.desc,
          list: list,
          name: trello_card.name,
          url: trello_card.url,
        }
      end

    end
  end
end
