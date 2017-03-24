module ScrumLint
  module Octokit
    # a mapper class to turn Octokit repos into ScrumLint repos
    class RepoMapper

      include Callable

      def call(octokit_repo, client:)
        ScrumLint::Repo.new(repo_params(octokit_repo, client))
      end

    private

      def repo_params(octokit_repo, client)
        {
          issues: mapped_issues(octokit_repo),
          pull_requests: mapped_pull_requests(octokit_repo, client),
          context: { milestones: octokit_repo.rels[:milestones].get.data },
        }
      end

      def mapped_issues(octokit_repo)
        octokit_repo.rels[:issues].get.data.map do |octokit_issue|
          issue_mapper.(octokit_issue)
        end
      end

      def mapped_pull_requests(octokit_repo, client)
        octokit_repo.rels[:pulls].get.data.map do |octokit_pull_request|
          pull_request_mapper.(octokit_pull_request, client: client)
        end
      end

      def issue_mapper
        @issue_mapper ||= ScrumLint::Octokit::IssueMapper.new
      end

      def pull_request_mapper
        @pull_request_mapper ||= ScrumLint::Octokit::PullRequestMapper.new
      end

    end
  end
end
