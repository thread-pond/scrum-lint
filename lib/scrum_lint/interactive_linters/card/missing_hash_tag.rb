module ScrumLint
  module InteractiveLinter
    # checks that cards have #HashTag and interactively assigns
    class MissingHashTag < InteractiveLinter::Base

      MESSAGE = 'missing hashtag'.freeze

      def call(card, reporter:, **_context)
        return if card.hashtags.any?

        reporter.fail(card, MESSAGE)
        reporter.get_value do |value|
          hashtags = value.split
          card.hashtags = hashtags
          card.save
        end
      end

    end
  end
end
