module ScrumLint
  # `ScrumLint::Card` is a wrapper class for `Trello::Card`. This allows us to
  # cache the list, as well as adding additional functionality going forward.
  class Card

    attr_reader(
      :board_name, :checklists, :desc, :hashtags, :labels, :list, :name,
      :point_count, :short_url, :task_text, :url
    )

    def initialize(
      board_name:, checklists:, desc:, list:, name:, url:, short_url:,
      source:, labels:
    )
      parsed_name = parse_name(name)
      @board_name = board_name
      @checklists = checklists
      @desc = desc
      @hashtags = parsed_name.fetch(:hashtags)
      @labels = labels
      @list = list
      @name = name
      @point_count = parsed_name.fetch(:point_count)
      @short_url = short_url
      @source = source
      @task_text = parsed_name.fetch(:task_text)
      @url = url
    end

    def tags
      @tags ||= CardTagger.(self)
    end

    def sub_entities
      []
    end

    def each
    end

    def desc=(desc)
      @source.desc = desc
    end

    def hashtags=(hashtags)
      @hashtags = hashtags
      @source.name = name_pieces.join(' ')
    end

    def name_pieces
      [
        ("(#{point_count})" if point_count),
        *hashtags,
        task_text,
      ].compact
    end

    def parse_name(name)
      segments = name.split
      hashtags, segments = segments.partition do |segment|
        segment.match(/^#\S+$/)
      end

      point_counts, segments = segments.partition do |segment|
        segment.match(/^\(\d+\)/)
      end

      raise "too many point counts #{point_counts}" if point_counts.size > 1

      point_count = point_counts.first
      {
        point_count: (Integer(point_count.gsub(/[()]/, '')) if point_count),
        hashtags: hashtags,
        task_text: segments.join(' '),
      }
    end

    def name=(name)
      @source.name = name
    end

    def add_label(label)
      @source.add_label(label)
    end

    def save
      @source.update!
    end

    def update_check_item_state(check_item, checklist:, state:)
      options = { checklist: checklist, state: state }
      @source.update_check_item_state(check_item, options)
    end

    def list_name
      list.name
    end

    def to_sym
      :card
    end

  end
end
