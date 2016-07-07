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
        [:task] => [
          InteractiveLinter::MissingHashTag,
          InteractiveLinter::MissingLabel,
        ],
        [:task, :active] => [
          InteractiveLinter::MissingContext,
          InteractiveLinter::MissingChecklistItem,
        ],
      },
      repo: {},
      issue: {},
    }.freeze

    def call(args = ARGV)
      options = ScrumLint::OptionParser.(args)

      ScrumLint::Configurator.()
      boards
      puts
      if options[:interactive]
        boards.each { |entity| run_interactive_linters(entity) }
      else
        boards.each { |entity| run_linters(entity) }
        repos.each { |repo| run_linters(repo) }
      end
    end

  private

    def repos
      ScrumLint.config.repo_source_class.()
    end

    def run_interactive_linters(entity, context: {})
      fetch_linters(entity, linters: INTERACTIVE_LINTERS).each do |linter|
        linter.(entity, context)
      end

      new_context = merge_context(entity: entity, context: context)
      entity.each do |item|
        run_interactive_linters(item, context: new_context)
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

  end
end
