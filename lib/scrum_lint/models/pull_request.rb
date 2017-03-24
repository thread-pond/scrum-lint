module ScrumLint
  # a wrapper class for Sawyer::Resource returned by Octokit
  class PullRequest

    attr_reader :assignees, :author, :client, :link, :milestone, :number, :repo_name, :reviewers, :title

    def initialize(assignees:, author:, client:, link:, milestone:, number:, repo_name:, reviewers:, title:)
      @assignees = assignees
      @author = author
      @client = client
      @link = link
      @milestone = milestone
      @number = number
      @repo_name = repo_name
      @reviewers = reviewers
      @title = title
    end

    def update(reviewers: nil, **params)
      assign_reviewers(reviewers) if reviewers
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

  private
    def assign_reviewers(reviewers)
      client.request_pull_request_review(
        repo_name,
        number,
        reviewers,
      )
    end
  end
end
