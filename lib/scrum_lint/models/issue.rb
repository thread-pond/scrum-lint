module ScrumLint
  # a wrapper class for Sawyer::Resource returned by Octokit
  class Issue

    attr_accessor :github_issue

    def initialize(github_issue)
      self.github_issue = github_issue
    end

    def title
      github_issue[:title]
    end

    def updated_at
      github_issue[:updated_at]
    end

    def link
      github_issue[:html_url]
    end

    def tags
      [:open]
    end

    def each
    end

    def to_sym
      :issue
    end

  end
end
