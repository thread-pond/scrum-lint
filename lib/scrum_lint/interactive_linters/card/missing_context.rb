module ScrumLint
  module InteractiveLinter
    # checks that cards have a context in their description in the form:
    #   Context: <link to a trello card>
    class MissingContext < InteractiveLinter::Base

      def call(card, active_project_cards:, **_)
        return if context?(card)

        puts "#{card.name.color(:green)} is missing 'Context' link"

        print_indexed(active_project_cards, :name)
        print "enter project number > "
        project_number = gets
        goodbye unless project_number

        return if project_number == "\n"

        project_card = active_project_cards[Integer(project_number) - 1]
        card.desc = "Context: #{project_card.url}\n\n#{card.desc}".strip
        card.save
      end

    private

      def context?(card)
        card.desc.match(/^Context:/)
      end

    end
  end
end
