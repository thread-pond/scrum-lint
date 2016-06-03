require 'trello'
require 'launchy'
require 'rainbow/ext/string'

require_relative '../util/callable'

require_relative 'scrum_lint/linters/board/current/missing_task_list'
require_relative 'scrum_lint/linters/board/current/extra_done_list'
require_relative 'scrum_lint/linters/board/current/extra_list'
require_relative 'scrum_lint/linters/board/current/missing_context'

require_relative 'scrum_lint/linters/card/done/missing_expended_points'
require_relative 'scrum_lint/linters/card/task/missing_hash_tag'

require_relative 'scrum_lint/linters/issue/open/stale_issue'

require_relative 'scrum_lint/version'
require_relative 'scrum_lint/configuration'
require_relative 'scrum_lint/configurator'
require_relative 'scrum_lint/runner'

require_relative 'scrum_lint/taggers/card_tagger'
require_relative 'scrum_lint/taggers/list_tagger'

require_relative 'scrum_lint/models/card'
require_relative 'scrum_lint/models/list'
require_relative 'scrum_lint/models/board'
require_relative 'scrum_lint/models/repo'
require_relative 'scrum_lint/models/issue'

module Launchy
  class << self
    alias_method :old_open, :open
    def open(url)
      @launch_count ||= 0
      @launch_count += 1
      old_open(url) if @launch_count < 10
      # puts "would have opened #{url}"
    end
  end
end

# Namespace for all `ScrumLint` code
module ScrumLint
  def self.config
    @config ||= ScrumLint::Configuration.new
  end
end
