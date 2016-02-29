module ScrumLint
  module Linter
    # Checks over the cards in the given board and prints out any that are
    # missing a context in their description in the form:
    #   Context: <link to a trello card>
    class MissingContext

      include Callable

      def call(board)
        board.task_lists.each do |list|
          cards = cards_without_context(list)
          if cards.any?
            puts "List #{list.name.color(:green)} has cards missing context:"
            cards.each { |card| puts "-> #{card.name.color(:blue)}" }
          end
        end
      end

    private

      def cards_without_context(list)
        list.cards.select { |card| !card.desc.match(/^Context:/) }
      end

    end
  end
end
