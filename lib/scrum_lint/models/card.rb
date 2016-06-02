module ScrumLint
  # `ScrumLint::Card` is a wrapper class for `Trello::Card`. This allows us to
  # cache the list, as well as adding additional functionality going forward.
  class Card

    attr_accessor :trello_card, :list

    def initialize(trello_card, list:)
      self.trello_card = trello_card
      self.list = list
    end

    def desc
      trello_card.desc
    end

    def name
      trello_card.name
    end

    def url
      trello_card.url
    end

    def tags
      @tags ||= CardTagger.(self)
    end

    def each
    end

    def list_name
      list.name
    end

    def to_sym
      :card
    end

  end
end
