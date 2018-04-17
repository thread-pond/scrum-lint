module ScrumLint
  # a wrapper class for Sawyer::Resource returned by Octokit
  class Issue

    attr_reader :link, :title, :updated_at

    def initialize(title:, updated_at:, link:)
      @title = title
      @updated_at = updated_at
      @link = link
    end

    def tags
      [:open]
    end

    def sub_entities
      []
    end

    def each; end

    def to_sym
      :issue
    end

  end
end
