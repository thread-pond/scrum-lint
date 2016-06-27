require 'trello'

module ScrumLint
  module InteractiveLinter
    # checks that cards have a checklist item on associated Context card
    class MissingChecklistItem < InteractiveLinter::Base

      def call(card, project_cards:, **_)
        /\AContext: (?<context_link>.*)\/.*$/i =~ card.desc
        return unless context_link

        project_card = project_cards.detect do |p_card|
          context_link.include?(p_card.short_url)
        end

        project_card ||= lookup_project_card(context_link)

        unless project_card
          raise "no project found for context link: #{card.name.color(:green)}"
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
            checklist.add_item(card.short_url)
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
          checklists[Integer(checklist_number) - 1].add_item(card.short_url)
        end
      end

    private

      def lookup_project_card(context_link)
        puts "looking up project card for #{context_link}"
        trello_card = ::Trello::Card.find(context_link.split('/').last)
        ScrumLint::Trello::CardMapper.call(trello_card, list: trello_card.list)
      end

    end
  end
end
