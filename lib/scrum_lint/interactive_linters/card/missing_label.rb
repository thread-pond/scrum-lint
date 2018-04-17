module ScrumLint
  module InteractiveLinter
    # checks that cards have Trello labels and interactively assigns
    class MissingLabel < InteractiveLinter::Base

      def call(card, available_labels:, **_context)
        return if label?(card)

        puts "card missing label: #{card.name.color(:green)}"
        print_indexed(available_labels, :name)
        print 'enter label number > '
        label_number = gets
        goodbye unless label_number
        label = available_labels[Integer(label_number) - 1]
        card.add_label(label)
      end

    private

      def label?(card)
        card.labels.any?
      end

    end
  end
end
