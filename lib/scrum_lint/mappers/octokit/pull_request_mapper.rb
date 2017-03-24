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
        {
          client: client,
          link: octokit_pull_request[:html_url],
          milestone: octokit_pull_request[:milestone],
          number: octokit_pull_request[:number],
          repo_name: octokit_pull_request.head.repo.full_name,
          title: octokit_pull_request[:title],
        }
      end

    end
  end
end
