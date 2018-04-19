module ScrumLint
  module InteractiveLinter
    # checks that cards have a context in their description in the form:
    #   Context: <link to a trello card>
    class MissingContext < InteractiveLinter::Base

      def call(card, active_project_cards:, **_context)
        return if context?(card) || active_project_cards.empty?

        puts "#{card.name.color(:green)} is missing 'Context' link"
        context_card = find_and_confirm_context_card(card, active_project_cards)

        return unless context_card

        puts "adding context: #{context_card.name}"
        card.desc = "Context: #{context_card.url}\n\n#{card.desc}".strip
        Thread.new { card.save }
      end

    private

      def context?(card)
        card.desc.match(/^Context:/)
      end

      def get_hashtag(string)
        string.slice(/#\w*/)
      end

      def find_and_confirm_context_card(card, active_project_cards)
        context_card = active_project_cards.detect do |project_card|
          get_hashtag(project_card.name) == get_hashtag(card.name)
        end

        if context_card
          suggest_context_card(context_card, active_project_cards)
        else
          pick_from_active_projects(active_project_cards)
        end
      end

      def suggest_context_card(context_card, active_project_cards)
        print "Add context link for #{context_card.name}? (y/n) > "
        confirmation = gets.chomp.downcase

        case confirmation
        when ''
          context_card
        when 'y'
          context_card
        when 'n'
          pick_from_active_projects(active_project_cards)
        else
          print_skip_message(confirmation)
        end
      end

      def pick_from_active_projects(active_project_cards)
        print_indexed(active_project_cards, :name)
        print 'enter project number > '
        user_input = gets.chomp
        project_number = user_input.to_i

        if project_number.between?(1, active_project_cards.length)
          active_project_cards[project_number - 1]
        else
          print_skip_message(user_input)
        end
      end

      def print_skip_message(choice)
        puts "#{choice} is not a valid option. "\
          'Skipping card; no context link added.'
      end

    end
  end
end
