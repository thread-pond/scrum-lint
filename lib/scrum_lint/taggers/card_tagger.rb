module ScrumLint
  # A class to identify tags that are appropriate for a card
  class CardTagger

    include Callable

    def call(card)
      [
        (:task if task_card?(card)),
        (:done if done_card?(card)),
        (:active if active_card?(card)),
        (:project if project_card?(card)),
      ].compact
    end

  private

    def task_card?(card)
      !project_card?(card)
    end

    def done_card?(card)
      card.list_name.match(ScrumLint.config.done_list_matcher)
    end

    def active_card?(card)
      !ScrumLint.config.ignored_list_names.include?(card.list_name)
    end

    def project_card?(card)
      card.name.match(/^\[\w+\]/)
    end

  end
end
