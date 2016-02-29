require 'trello'
require 'rainbow/ext/string'

require_relative '../util/callable'

require_relative 'scrum_lint/version'
require_relative 'scrum_lint/configuration'
require_relative 'scrum_lint/configurator'
require_relative 'scrum_lint/runner'

require_relative 'scrum_lint/models/card'
require_relative 'scrum_lint/models/list'
require_relative 'scrum_lint/models/board'

require_relative 'scrum_lint/linter/missing_task_list'
require_relative 'scrum_lint/linter/extra_list'
require_relative 'scrum_lint/linter/missing_context'

# Namespace for all `ScrumLint` code
module ScrumLint
  def self.config
    @config ||= ScrumLint::Configuration.new
  end
end
