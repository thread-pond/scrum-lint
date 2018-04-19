require 'trello'

module Trello
  # monkey patch to allow updating check items on card
  class Card < BasicData

    def update_check_item_state(check_item, checklist:, state:)
      unless %w[complete incomplete].include?(state)
        raise "invalid state #{state}"
      end

      client.put(
        "/cards/#{id}" \
        "/checklist/#{checklist.id}" \
        "/checkItem/#{check_item.id}/state",
        value: state
      )
    end

  end
end
