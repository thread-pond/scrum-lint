module ScrumLint
  module Linter
    # checks for issues on Github that haven't been updated in the past 24 hours
    class StaleIssue

      include Callable

      def call(issue)
        return if updated_recently?(issue)

        puts "issue hasn't been updated recently: " \
          "#{issue.title.color(:green)} (#{issue.link.color(:blue)})"
      end

    private

      def updated_recently?(issue)
        seconds_since_updated(issue) < twenty_four_hours_in_seconds
      end

      def seconds_since_updated(issue)
        Time.now - issue.updated_at.localtime
      end

      def twenty_four_hours_in_seconds
        60 * 60 * 24
      end
    end

  end
end
