module ScrumLint
  module Trello
    # a mapper class to turn Ruby Trello cards into ScrumLint cards
    class CardMapper

      include Callable

      def call(trello_card, list:, available_labels:)
        ScrumLint::Card.new(card_params(trello_card, list: list, available_labels: available_labels))
      end

    private

      def card_params(trello_card, list:, available_labels:)
        {
          available_labels: available_labels,
          labels: trello_card.card_labels,
          desc: trello_card.desc,
          list: list,
          name: trello_card.name,
          url: trello_card.url,
          source: trello_card,
        }
      end

    end
  end
end
