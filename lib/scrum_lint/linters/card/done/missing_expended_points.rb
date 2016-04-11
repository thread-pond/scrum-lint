module ScrumLint
  module Linter
    # checks that finished cards have expended points
    class MissingExpendedPoints

      include Callable

      def call(card)
        return if project_card?(card) || card.name.match(/\[\d+(\.\d+)?\]$/)

        puts "card missing expended points: #{card.name.color(:green)}"
      end

    private

      def project_card?(card)
        card.tags.include?(:project)
      end

    end
  end
end
