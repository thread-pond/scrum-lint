module ScrumLint
  # a wrapper class for a Github repo from Octokit
  class Repo

    attr_reader :issues, :pull_requests, :context

    def initialize(issues:, pull_requests:, context:)
      @context = context
      @issues = issues
      @pull_requests = pull_requests
    end

    def sub_entities
      pull_requests
    end

    def each
      pull_requests.each { |pull_request| yield(pull_request) }
    end

    def tags
      [:active]
    end

    def to_sym
      :repo
    end

  end
end
