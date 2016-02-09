class TrelloPure

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

  end

end
