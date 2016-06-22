module ScrumLint
  # `ScrumLint::Board` is a wrapper class for `Trello::Board`. It allows us to
  # cache the lists in memory, as well as adding other useful methods to query
  # for specific lists.
  class Board

    attr_reader :context, :lists, :name, :url

    def initialize(lists:, name:, url:, context:)
      @context = context
      @lists = lists
      @name = name
      @url = url
    end

    def list_names
      @list_names ||= lists.map(&:name)
    end

    def done_lists
      @done_lists ||= lists.select { |list| done_list_name?(list.name) }
    end

    def task_lists
      @task_lists ||= lists.select { |list| task_list_name?(list.name) }
    end

    def tags
      [:current]
    end

    def each
      lists.each { |list| yield(list) }
    end

    def to_sym
      :board
    end

  private

    def task_list_name?(name)
      ScrumLint.config.task_list_names.include?(name) # || done_list_name?(name)
    end

    def done_list_name?(name)
      name.match(ScrumLint.config.done_list_matcher)
    end

  end
end
