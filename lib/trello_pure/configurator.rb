class TrelloPure

  class Configurator

    def self.call
      Trello.configure do |trello_config|
        trello_config.developer_public_key = trello_developer_public_key
        trello_config.member_token = trello_member_token
      end
    end

  private

    def self.trello_developer_public_key
      TrelloPure.config.trello_developer_public_key
    end

    def self.trello_member_token
      TrelloPure.config.trello_member_token
    end

  end

end
