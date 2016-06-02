module ScrumLint
  module Linter
    # checks that cards all have #HashTag to link to a project
    class MissingHashTag

      include Callable

      def call(card)
        return if hashtag?(card)

        Launchy.open(card.url)
        puts "card missing hashtag: #{card.name.color(:blue)} " \
          "in list #{card.list.name.color(:green)}"
      end

    private

      def hashtag?(card)
        !card.name.match(/#\w+/).nil?
      end

    end
  end
end
