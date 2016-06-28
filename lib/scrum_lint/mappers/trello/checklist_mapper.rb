module ScrumLint
  module Trello
    # a mapper class to turn Ruby Trello checklists into ScrumLint checklists
    class ChecklistMapper

      include Callable

      def call(trello_checklist)
        ScrumLint::Checklist.new(checklist_params(trello_checklist))
      end

    private

      def checklist_params(trello_checklist)
        {
          items: trello_checklist.items,
          name: trello_checklist.name,
          source: trello_checklist,
        }
      end

    end
  end
end

