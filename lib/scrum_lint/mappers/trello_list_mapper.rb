module ScrumLint
  # a mapper class to turn Ruby Trello lists into ScrumLint lists
  class TrelloListMapper

    include Callable

    def call(trello_list)
      ScrumLint::List.new(list_params(trello_list)).tap do |list|
        list.cards = mapped_cards(list: list, trello_list: trello_list)
      end
    end

  private

    def list_params(trello_list)
      { name: trello_list.name }
    end

    def mapped_cards(list:, trello_list:)
      trello_list.cards.map { |card| ScrumLint::Card.new(card, list: list) }
    end

  end
end
