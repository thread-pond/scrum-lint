module ScrumLint
  # `ScrumLint::List` is a wrapper class for `Trello::List`. This allows us to
  # cache the cards in memory instead of requesting for them each time. It will
  # also allow us to add additional functionality such as predicate methods.
  class List

    attr_accessor :cards
    attr_reader :name

    def initialize(name:)
      @cards = cards
      @name = name
    end

    def tags
      @tags ||= ListTagger.(self)
    end

    def sub_entities
      cards
    end

    def each
      cards.each { |card| yield(card) }
    end

    def to_sym
      :list
    end

  end
end
