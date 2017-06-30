require 'trello'

module ScrumLint
  module InteractiveLinter
    # checks that cards have a checklist item on associated Context card
    class MissingChecklistItem < InteractiveLinter::Base

      def call(card, project_cards:, **_)
        /\AContext: (?<context_link>.*)\/.*$/i =~ card.desc
        return unless context_link

        unless context_link =~ /trello.com/
          raise "invalid context link for #{card.name.color(:green)}"
        end

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

        checklists = project_card.checklists
        return if checklists.flat_map(&:items).any? do |item|
          item.name.include?(card.short_url)
        end

        puts "card #{card.name.color(:green)} missing checklist item"
        puts "on project card #{project_card.name.color(:blue)}"
        case checklists.length
        when 1
          checklist = checklists.first
          print "add card to list #{checklist.name.color(:blue)}? (y/n) > "
          confirmation = gets
          goodbye unless confirmation
          case confirmation.chomp.downcase
          when '', 'y'
            Thread.new { checklist.add_item(card.short_url) }
          else
            puts 'skipping card'
          end
        when 0
          puts 'no checklist on card'
        else
          print_indexed(checklists, :name)

          print 'enter a checklist number > '
          checklist_number = gets
          goodbye unless checklist_number
          Thread.new do
            checklists[Integer(checklist_number) - 1].add_item(card.short_url)
          end
        end
      end

    private

      def lookup_project_card(context_link)
        puts "looking up project card for #{context_link}"
        trello_card = ::Trello::Card.find(context_link.split('/').last)
        ScrumLint::Trello::CardMapper.(
          trello_card,
          list: trello_card.list,
          board_name: trello_card.board.name,
        )
      end

    end
  end
end
