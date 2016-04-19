require 'octokit'

module ScrumLint

  class Repo

    attr_accessor :github_repo

    def self.each
      ScrumLint.config.github_repo_names.each do |repo_name|
        yield(new(client.repository(repo_name)))
      end
    end

    def initialize(github_repo)
      self.github_repo = github_repo
    end

    def each
      github_repo.rels[:issues].get.data.each do |github_issue|
        yield(Issue.new(github_issue))
      end
    end

    def tags
      [:active]
    end

    def to_sym
      :repo
    end

  private

    def self.client
      @client ||= Octokit::Client.new(access_token: access_token)
    end

    def self.access_token
      ScrumLint.config.github_access_token
    end
  end

end
