module ScrumLint
  module Linter
    # checks that finished cards have expended points
    class MissingExpendedPoints

      include Callable

      def call(card)
        return if card.name.match(/\[\d+(\.\d+)?\]$/)

        Launchy.open(card.url)
        puts "card missing expended points: #{card.name.color(:green)}"
      end

    end
  end
end
