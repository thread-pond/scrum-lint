module ScrumLint
  # `ScrumLint::Checklist` is a wrapper class for `Trello::Checklist`
  class Checklist

    attr_reader :items, :name

    def initialize(items:, name:, source:)
      @items = items
      @name = name
      @source = source
    end

    def add_item(item)
      @source.add_item(item)
    end

    def id
      @source.id
    end

  end
end
