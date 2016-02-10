class ScrumLint

  class Configurator

    def self.call
      Trello.configure do |trello_config|
        trello_config.developer_public_key = trello_developer_public_key
        trello_config.member_token = trello_member_token
      end
    end

  private

    def self.trello_developer_public_key
      ScrumLint.config.trello_developer_public_key
    end

    def self.trello_member_token
      ScrumLint.config.trello_member_token
    end

  end

end
