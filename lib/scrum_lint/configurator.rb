module ScrumLint

  class Configurator

    def self.call
      new.()
    end

    def call
      Trello.configure do |trello_config|
        trello_config.developer_public_key = trello_developer_public_key
        trello_config.member_token = trello_member_token
      end
    end

  private

    def trello_developer_public_key
      ScrumLint.config.trello_developer_public_key
    end

    def trello_member_token
      ScrumLint.config.trello_member_token
    end

  end

end
