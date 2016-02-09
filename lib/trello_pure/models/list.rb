require_relative 'card'

class TrelloPure

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
        TrelloPure::Card.new(card, list: self)
      end
    end

  end

end
