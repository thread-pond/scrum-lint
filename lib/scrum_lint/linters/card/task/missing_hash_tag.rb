module ScrumLint
  module Linter
    # checks that cards all have #HashTag to link to a project
    class MissingHashTag

      include Callable

      def call(card)
        return if hashtag?(card)

        puts "card missing hashtag: #{card.name.color(:green)}"
      end

    private

      def hashtag?(card)
        !card.name.match(/#\w+/).nil?
      end

    end
  end
end
