module ScrumLint

  class Configuration

    DEFAULT_CONFIGURATION = {
      board_name:      'Eng: Current',
      task_list_names: ['Planned', 'This Sprint', 'Doing', 'In Review'],
      done_list_matcher: /^Done.*$/,
      project_list_names: ['Active Projects'],
      ignored_list_names: %w(Emergent),
      trello_developer_public_key: ENV.fetch('TRELLO_DEVELOPER_PUBLIC_KEY'),
      trello_member_token: ENV.fetch('TRELLO_MEMBER_TOKEN'),
    }.freeze

    attr_accessor(*DEFAULT_CONFIGURATION.keys)

    def initialize
      loaded_options = load_yaml_config
      DEFAULT_CONFIGURATION.each do |key, value|
        self.send("#{key}=", loaded_options.fetch(key, value))
        loaded_options.delete(key)
      end
      raise "invalid options: #{loaded_options.keys}" if loaded_options.any?
    end

  private

    def load_yaml_config
      {}
    end

  end

end
