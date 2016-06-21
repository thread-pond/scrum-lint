module ScrumLint
  module InteractiveLinter
    # checks that cards have Trello labels and interactively assigns
    class MissingLabel < InteractiveLinter::Base

      def call(card)
        return if label?(card)

        puts "card missing label: #{card.name.color(:green)}"
        puts available_labels(card)
        print "enter label number > "
        label_number = gets
        goodbye unless label_number
        label = card.available_labels[Integer(label_number) - 1]
        card.add_label(label)
      end

    private

      def label?(card)
        card.labels.any?
      end

      def available_labels(card)
        card.available_labels.each_with_index.map do |label, index|
          "#{index + 1}. #{label.name}"
        end.join("\n")
      end

    end
  end
end
