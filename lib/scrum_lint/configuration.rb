require 'yaml'
require 'erb'

module ScrumLint

  class Configuration

    DEFAULT_CONFIGURATION = {
      board_name:      'Eng: Current',
      task_list_names: ['Planned', 'This Sprint', 'Doing', 'In Review'],
      done_list_matcher: /^Done.*$/,
      project_list_names: ['Active Projects'],
      ignored_list_names: %w(Emergent),
    }.freeze

    REQUIRED_CONFIGURATION_KEYS = [
      :trello_developer_public_key,
      :trello_member_token,
    ].freeze

    CONFIGURATION_KEYS =
      (DEFAULT_CONFIGURATION.keys + REQUIRED_CONFIGURATION_KEYS).freeze

    attr_accessor(*CONFIGURATION_KEYS)

    def initialize
      options = load_yaml_config.merge(DEFAULT_CONFIGURATION)

      CONFIGURATION_KEYS.each do |key|
        self.send("#{key}=", options.fetch(key))
        options.delete(key)
      end
      raise "invalid options: #{options.keys}" if options.any?
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
