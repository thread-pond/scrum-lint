module ScrumLint
  module InteractiveLinter
    # checks for pull requests on Github that need a reviewer
    class MissingReviewer < InteractiveLinter::Base

      include Callable

      def call(pull_request, reviewers:, **)
        return if pull_request.reviewers.any? || pull_request.assignees.any?

        exceptions = ScrumLint.config.github_out_of_office + [pull_request.author]
        shuffled_reviewers = (reviewers - exceptions).shuffle
        reviewer = shuffled_reviewers.first

        puts "Assigning #{reviewer.color(:green)} to " \
          "PR #{pull_request.name.color(:red)} " \
          "(#{pull_request.author.color(:yellow)}). " \
          "Type 's' to manually assign (ENTER/s)> "

        choice = gets
        goodbye unless choice.strip == 's' || choice.strip.empty?

        if choice.strip == 's'
          print_indexed(shuffled_reviewers, :itself)
          print 'Enter reviewer number > '
          reviewer_number = gets
          goodbye unless reviewer_number
          return if reviewer_number.blank?
          reviewer = shuffled_reviewers[Integer(reviewer_number) -1]
        end

        pull_request.update(assignee: reviewer, reviewers: [reviewer])
      end

    end
  end
end
