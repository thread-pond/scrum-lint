module ScrumLint
  module InteractiveLinter
    # checks for pull requests on Github that aren't associated with a milestone
    class MissingMilestone < InteractiveLinter::Base

      include Callable

      def call(pull_request, milestones:, **)
        return if pull_request.milestone

        sorted_milestones = milestones.sort_by(&:title)
        puts "Pull request #{pull_request.title.color(:red)}" \
          " is missing a milestone."
        print_indexed(sorted_milestones, :title)
        print 'enter milestone number > '
        milestone_number = gets
        goodbye unless milestone_number
        return if milestone_number.blank?
        milestone = sorted_milestones[Integer(milestone_number) - 1]
        pull_request.update(milestone: milestone.number)
      end

    end
  end
end
