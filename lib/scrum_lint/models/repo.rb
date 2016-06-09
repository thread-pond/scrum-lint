require 'octokit'

module ScrumLint
  # a wrapper class for a Github repo from Octokit
  class Repo

    attr_accessor :github_repo

    class << self

      def each
        ScrumLint.config.github_repo_names.each do |repo_name|
          yield(new(client.repository(repo_name)))
        end
      end

    private

      def client
        @client ||= Octokit::Client.new(access_token: access_token)
      end

      def access_token
        ScrumLint.config.github_access_token
      end

    end

    def initialize(github_repo)
      self.github_repo = github_repo
    end

    def each
      issues.each do |github_issue|
        yield(Issue.new(github_issue))
      end
    end

    def issues
      github_repo.rels[:issues].get.data
    end

    def tags
      [:active]
    end

    def to_sym
      :repo
    end

  end
end
