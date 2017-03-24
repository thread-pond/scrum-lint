require 'optparse'

module ScrumLint
  # `ScrumLint::Runner` is where it all begins. It sets up configuration, looks
  # up and validates the board, and then runs the lints
  class Runner

    include Callable

    LINTERS = {
      board: {
        [:current] => [
          Linter::ExtraList,
          Linter::ExtraDoneList,
          Linter::MissingTaskList,
        ],
        [:backlog] => [],
      },
      list: {
        [:task] => [],
        [:done] => [],
        [:project] => [],
      },
      card: {
        [:task] => [Linter::MissingHashTag],
        [:task, :active] => [Linter::MissingContext],
        [:task, :done] => [Linter::MissingExpendedPoints],
        [:project] => [],
      },
      repo: {
        [:active] => [],
      },
      issue: {
        [:open] => [Linter::StaleIssue],
      },
    }.freeze

    INTERACTIVE_LINTERS = {
      board: {},
      list: {},
      card: {
        InteractiveLinter::MissingHashTag => [:task],
        InteractiveLinter::MissingLabel => [:task],
        InteractiveLinter::MissingContext => [:task, :active],
        InteractiveLinter::MissingChecklistItem => [:task, :active],
        InteractiveLinter::ChecklistItemNotCompleted => [:task, :done],
      },
      repo: {},
      issue: {},
      pull_request: {
        InteractiveLinter::MissingMilestone => [:open],
      },
    }.freeze

    def call(args = ARGV)
      options = ScrumLint::OptionParser.(args)

      ScrumLint::Configurator.()
      # boards
      puts
      if options[:interactive]
        reporter = ScrumLint::Reporters::InteractiveReporter.new
        # run_interactive_linters(boards, context: { reporter: reporter })
        run_interactive_linters(repos, context: { reporter: reporter })
      else
        boards.each { |entity| run_linters(entity) }
        repos.each { |repo| run_linters(repo) }
      end
    end

  private

    def run_interactive_linters(entities, context:)
      return unless entities.any?

      linter_tag_map = INTERACTIVE_LINTERS.fetch(entities.first.to_sym)
      linter_tag_map.each do |linter, tags|
        entities.sort_by(&:name).each do |entity|
          next unless tags - entity.tags == []

          linter.(entity, context)
        end
      end

      entities.each do |entity|
        new_context = merge_context(entity: entity, context: context)
        run_interactive_linters(entity.sub_entities, context: new_context)
      end
    end

    def merge_context(entity:, context:)
      entity.respond_to?(:context) ? context.merge(entity.context) : context
    end

    def run_linters(entity)
      fetch_linters(entity).each do |linter|
        linter.(entity)
      end

      entity.each do |item|
        run_linters(item)
      end
    end

    def fetch_linters(entity, linters: LINTERS)
      entity_linters = linters[entity.to_sym]
      keys_matching_tags = entity_linters.keys.select do |key|
        Set.new(entity.tags) >= Set.new(key)
      end
      entity_linters.values_at(*keys_matching_tags).flatten.uniq
    end

    def boards
      @boards ||= ScrumLint.config.board_source_class.()
    end

    def repos
      @repos ||= ScrumLint.config.repo_source_class.()
    end

  end
end
