module ScrumLint
  # a mapper class to turn Octokit issues into ScrumLint issues
  class OctokitIssueMapper

    include Callable

    def call(octokit_issue)
      ScrumLint::Issue.new(issue_params(octokit_issue))
    end

  private

    def issue_params(octokit_issue)
      {
        link: octokit_issue[:html_url],
        title: octokit_issue[:title],
        updated_at: octokit_issue[:updated_at],
      }
    end

  end
end
