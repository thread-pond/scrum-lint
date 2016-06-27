module ScrumLint
  module InteractiveLinter
    # checks that cards have a checklist item on associated Context card
    class MissingChecklistItem < InteractiveLinter::Base

      def call(card, project_cards:, **_)
        /\AContext: (?<context_link>.*$)/i =~ card.desc
        return unless context_link

        project_card = project_cards.detect { |p_card| p_card.url == context_link }

        raise "no card for link: #{context_link}" unless project_card

        checklists = project_card.checklists
        return if checklists.flat_map(&:items).any? { |item| item.name == card.url }

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
            checklist.add_item(card.url)
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
          checklists[Integer(checklist_number)].add_item(card.url)
        end
      end

    end
  end
end
