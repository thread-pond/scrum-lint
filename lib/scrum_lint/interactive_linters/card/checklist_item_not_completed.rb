module ScrumLint
  module InteractiveLinter
    # checks that checklist item on project card is checked off
    class ChecklistItemNotCompleted

      include Callable

      def call(card, project_cards:, **_context)
        /\AContext: (?<context_link>.*)\/.*$/i =~ card.desc
        return unless context_link

        project_card = project_cards.detect do |p_card|
          context_link.include?(p_card.short_url)
        end

        unless project_card
          project_card = lookup_project_card(context_link)

          unless project_card
            raise "no project found for context: #{card.name.color(:green)}"
          end
          project_cards << project_card
        end

        checklists = project_card.checklists.select do |checklist|
          checklist.items.any? { |item| item.name.include?(card.short_url) }
        end

        return unless checklists.any?

        if checklists.size > 1
          raise 'multiple checklists match: ' \
            "project card: #{project_card.short_url}, " \
            "task card: #{card.short_url}"
        end

        checklist = checklists.first

        check_items = checklist.items.select do |check_item|
          check_item.name.include?(card.short_url)
        end

        if check_items.size > 1
          puts 'Skipping, multiple items match: ' \
            "project card: #{project_card.short_url}, " \
            "task card: #{card.short_url}"
          return
        end

        check_item = check_items.first

        return unless check_item.state == 'incomplete'

        puts "task #{card.name.color(:green)} should be marked complete " \
          "on project #{project_card.name.color(:blue)}"
        print 'mark check item completed? (y/n) > '
        confirmation = gets
        goodbye unless confirmation
        case confirmation.chomp.downcase
        when '', 'y'
          Thread.new do
            options = { checklist: checklist, state: 'complete' }
            project_card.update_check_item_state(check_item, options)
          end
        else
          puts 'skipping card'
        end
      end

    private

      def lookup_project_card(context_link)
        puts "looking up project card for #{context_link}"
        trello_card = ::Trello::Card.find(context_link.split('/').last)
        ScrumLint::Trello::CardMapper.(trello_card, list: trello_card.list)
      end

    end
  end
end
