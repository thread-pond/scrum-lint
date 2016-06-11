require 'octokit'

module ScrumLint
  # a mapper class to query Github via Octokit and return a mapped tree
  # of ScrumLint models
  class OctokitMapper

    include Callable

    def call
      ScrumLint.config.github_repo_names.map do |repo_name|
        repo_mapper.(client.repository(repo_name))
      end
    end

  private

    def repo_mapper
      @repo_mapper ||= ScrumLint::OctokitRepoMapper.new
    end

    def client
      @client ||= Octokit::Client.new(access_token: access_token)
    end

    def access_token
      ScrumLint.config.github_access_token
    end

  end
end
