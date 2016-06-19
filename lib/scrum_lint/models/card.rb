module ScrumLint
  # `ScrumLint::Card` is a wrapper class for `Trello::Card`. This allows us to
  # cache the list, as well as adding additional functionality going forward.
  class Card

    attr_reader :desc, :list, :name, :url

    def initialize(desc:, list:, name:, url:, source:)
      @desc = desc
      @list = list
      @name = name
      @url = url
      @source = source
    end

    def tags
      @tags ||= CardTagger.(self)
    end

    def each
    end

    def name=(name)
      @source.name = name
    end

    def save
      @source.update!
    end

    def list_name
      list.name
    end

    def to_sym
      :card
    end

  end
end
