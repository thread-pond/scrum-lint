module ScrumLint
  module Trello
    # a mapper class to turn Ruby Trello cards into ScrumLint cards
    class CardMapper

      include Callable

      def call(trello_card, list:)
        ScrumLint::Card.new(card_params(trello_card, list: list))
      end

    private

      def card_params(trello_card, list:)
        {
          labels: trello_card.card_labels,
          desc: trello_card.desc,
          list: list,
          name: trello_card.name,
          short_url: trello_card.short_url,
          url: trello_card.url,
          source: trello_card,
          checklists: mapped_checklists(trello_card),
        }
      end

      def mapped_checklists(trello_card)
        return [] unless project_card?(trello_card)
        trello_card.checklists.map do |trello_checklist|
          checklist_mapper.(trello_checklist)
        end
      end

      def project_card?(card)
        card.name.match(/^\[\w+\]/)
      end

      def checklist_mapper
        @checklist_mapper ||= ScrumLint::Trello::ChecklistMapper.new
      end

    end
  end
end
