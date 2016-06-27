module ScrumLint
  # `ScrumLint::Card` is a wrapper class for `Trello::Card`. This allows us to
  # cache the list, as well as adding additional functionality going forward.
  class Card

    attr_reader :desc, :labels, :list, :name, :url

    def initialize(desc:, list:, name:, url:, source:, labels:)
      @desc = desc
      @labels = labels
      @list = list
      @name = name
      @source = source
      @url = url
    end

    def tags
      @tags ||= CardTagger.(self)
    end

    def each
    end

    def checklists
      @source.checklists
    end

    def desc=(desc)
      @source.desc = desc
    end

    def name=(name)
      @source.name = name
    end

    def add_label(label)
      @source.add_label(label)
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
