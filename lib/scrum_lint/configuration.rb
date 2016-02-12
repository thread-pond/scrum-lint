module ScrumLint

  module Configuration
    def self.new
      OpenStruct.new(
        board_name: 'Eng: Current',
        task_list_names: ['Planned', 'This Sprint', 'Doing', 'In Review'],
        done_list_matcher: /^Done.*$/,
        project_list_names: ['Active Projects'],
        ignored_list_names: %w(Emergent),
        trello_developer_public_key: ENV.fetch('TRELLO_DEVELOPER_PUBLIC_KEY'),
        trello_member_token: ENV.fetch('TRELLO_MEMBER_TOKEN'),
      )
    end
  end

end
