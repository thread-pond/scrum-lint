module ScrumLint
  # `ScrumLint::Card` is a wrapper class for `Trello::Card`. This allows us to
  # cache the list, as well as adding additional functionality going forward.
  class Card

    attr_reader :desc, :list, :name, :url

    def initialize(desc:, list:, name:, url:)
      @desc = desc
      @list = list
      @name = name
      @url = url
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
