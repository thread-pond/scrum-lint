module ScrumLint
  module Octokit
    # a mapper class to turn Octokit repos into ScrumLint repos
    class RepoMapper

      include Callable

      def call(octokit_repo)
        ScrumLint::Repo.new(repo_params(octokit_repo))
      end

    private

      def repo_params(octokit_repo)
        { issues: mapped_issues(octokit_repo) }
      end

      def mapped_issues(octokit_repo)
        octokit_repo.rels[:issues].get.data.map do |octokit_issue|
          issue_mapper.(octokit_issue)
        end
      end

      def issue_mapper
        @issue_mapper ||= ScrumLint::Octokit::IssueMapper.new
      end

    end
  end
end
