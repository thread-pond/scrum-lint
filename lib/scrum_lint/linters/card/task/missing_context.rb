module ScrumLint
  module Linter
    # checks that cards have a context in their description in the form:
    #   Context: <link to a trello card>
    class MissingContext

      include Callable

      def call(card)
        return if context?(card) && card.list.name != 'Emergent'
        Launchy.open(card.url)
        puts "#{card.name.color(:blue)} has missing Context"
      end

    private

      def context?(card)
        card.desc.match(/^Context:/)
      end

    end
  end
end
