module ScrumLint
  # A class to identify tags that are appropriate for a list
  class ListTagger

    def call(list)
      [
        (:task if task_list?(list)),
        (:done if done_list?(list)),
      ].compact
    end

  private

    def task_list?(_list)
      true
    end

    def done_list?(list)
      list.name.match(ScrumLint.config.done_list_matcher)
    end

  end
end
