module ScrumLint
  module InteractiveLinter
    # checks that cards have #HashTag and interactively assigns
    class MissingHashTag < InteractiveLinter::Base

      def call(card, **_)
        return if card.hashtags.any?

        puts "card missing hashtag: #{card.name.color(:green)}"
        print 'enter tag(s) > '
        tag_string = gets
        goodbye unless tag_string
        hashtags = tag_string.strip.split
        colored_tags = hashtags.join(' ').color(:blue)
        print "new hashtags will be #{colored_tags}, confirm? (y/n) > "
        confirmation = gets
        goodbye unless confirmation
        case confirmation.chomp.downcase
        when '', 'y'
          card.hashtags = hashtags
          card.save
        when 'exit', 'quit'
          goodbye
        else
          puts 'skipping card'
        end
      end

    end
  end
end
