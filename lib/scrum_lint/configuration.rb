require 'yaml'
require 'erb'

module ScrumLint
  # `ScrumLint::Configuration` loads in the configuration from the
  # `.scrum-lint.yml` file in the current directory, and merges it into the
  # default configurations. A project must have at minimum a configuration file
  # with keys `trello_developer_public_key` and `trello_member_token`
  class Configuration

    DEFAULT_CONFIGURATION = {
      board_names:      ['Eng: Current'],
      current_board_names: ['Eng: Current'],
      task_list_names: ['Planned', 'This Sprint', 'Doing', 'In Review'],
      done_list_matcher: /^Done.*$/,
      project_list_names: ['Active Projects'],
      ignored_list_names: %w(Emergent),
      repo_source: 'Octokit',
      board_source: 'Trello',
      github_reviewers: [],
    }.freeze

    REQUIRED_CONFIGURATION_KEYS = [
      :trello_developer_public_key,
      :trello_member_token,
      :github_access_token,
      :github_repo_names,
    ].freeze

    CONFIGURATION_KEYS =
      (DEFAULT_CONFIGURATION.keys + REQUIRED_CONFIGURATION_KEYS).freeze

    attr_accessor(*CONFIGURATION_KEYS)

    def initialize
      options = DEFAULT_CONFIGURATION.merge(load_yaml_config)

      CONFIGURATION_KEYS.each do |key|
        public_send("#{key}=", options.fetch(key))
        options.delete(key)
      end
      raise "invalid options: #{options.keys}" if options.any?
    end

    def repo_source_class
      ScrumLint.const_get(repo_source)::Source
    end

    def board_source_class
      ScrumLint.const_get(board_source)::Source
    end

  private

    def load_yaml_config
      unless File.exist?(config_file_path)
        abort('Please add a ".scrum-lint.yml" file and try again')
      end
      symbolize_keys(YAML.safe_load(config_file_contents))
    end

    def config_file_contents
      ERB.new(IO.read(config_file_path)).result
    end

    def config_file_path
      './.scrum-lint.yml'
    end

    def symbolize_keys(hash)
      hash.each_with_object({}) do |(key, value), result|
        new_key = key.is_a?(String) ? key.to_sym : key
        new_value = value.is_a?(Hash) ? symbolize_keys(value) : value
        result[new_key] = new_value
      end
    end

  end
end
