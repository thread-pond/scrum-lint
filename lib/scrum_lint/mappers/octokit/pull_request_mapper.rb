module ScrumLint
  module Octokit
    # a mapper class to turn Octokit pull request into ScrumLint pull request
    class PullRequestMapper

      include Callable

      def call(octokit_pull_request, client:)
        ScrumLint::PullRequest.new(pull_request_params(octokit_pull_request, client))
      end

    private

      def pull_request_params(octokit_pull_request, client)
        repo_name = octokit_pull_request.head.repo.full_name
        number = octokit_pull_request[:number]

        {
          assignees: octokit_pull_request[:assignees].map(&:login),
          author: octokit_pull_request[:user].login,
          client: client,
          link: octokit_pull_request[:html_url],
          milestone: octokit_pull_request[:milestone],
          number: number,
          repo_name: repo_name,
          reviewers: client.pull_request_review_requests(
            repo_name,
            number,
            accept: 'application/vnd.github.black-cat-preview+json',
          ).map(&:login),
          title: octokit_pull_request[:title],
        }
      end

    end
  end
end
