module ScrumLint
  # a wrapper class for Sawyer::Resource returned by Octokit
  class PullRequest

    attr_reader :client, :link, :milestone, :number, :repo_name, :title

    def initialize(client:, link:, milestone:, number:, repo_name:, title:)
      @client = client
      @link = link
      @milestone = milestone
      @number = number
      @repo_name = repo_name
      @title = title
    end

    def update(**params)
      client.update_issue(repo_name, number, params)
    end

    def name
      title
    end

    def tags
      [:open]
    end

    def sub_entities
      []
    end

    def each
    end

    def to_sym
      :pull_request
    end

  end
end
