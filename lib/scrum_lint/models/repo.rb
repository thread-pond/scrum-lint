require 'octokit'

module ScrumLint
  # a wrapper class for a Github repo from Octokit
  class Repo

    attr_reader :issues

    def initialize(issues:)
      @issues = issues
    end

    def each
      issues.each { |issue| yield(issue) }
    end

    def tags
      [:active]
    end

    def to_sym
      :repo
    end

  end
end
