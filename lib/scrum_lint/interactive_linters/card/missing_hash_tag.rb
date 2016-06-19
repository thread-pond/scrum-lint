module ScrumLint
  module InteractiveLinter
    # checks that cards have #HashTag and interactively assigns
    class MissingHashTag

      include Callable

      def call(card)
        return if hashtag?(card)

        puts "card missing hashtag: #{card.name.color(:green)}"
        print "enter tag(s) > "
        tag = gets
        goodbye unless tag
        new_name = "#{tag.strip} #{card.name}"
        print "new name will be #{new_name.color(:blue)}, confirm? (y/n) > "
        confirmation = gets
        goodbye unless confirmation
        case confirmation.chomp.downcase
        when '', 'y'
          card.name = new_name
          card.save
        when 'exit', 'quit'
          goodbye
        else
          puts 'skipping card'
        end
      end

    private

      def goodbye
        puts
        puts 'goodbye'
        exit
      end

      def hashtag?(card)
        !card.name.match(/#\w+/).nil?
      end

    end
  end
end

