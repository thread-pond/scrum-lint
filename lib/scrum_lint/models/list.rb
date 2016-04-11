module ScrumLint
  # `ScrumLint::List` is a wrapper class for `Trello::List`. This allows us to
  # cache the cards in memory instead of requesting for them each time. It will
  # also allow us to add additional functionality such as predicate methods.
  class List

    attr_accessor :trello_list

    def initialize(trello_list)
      self.trello_list = trello_list
    end

    def name
      trello_list.name
    end

    def cards
      @cards ||= trello_list.cards.map do |card|
        ScrumLint::Card.new(card, list: self)
      end
    end

    def tags
      [:task]
    end

    def to_sym
      :list
    end

  end
end
