require 'trello'
require 'colorize'

require_relative '../util/callable'

require_relative 'scrum_lint/version'
require_relative 'scrum_lint/board_validator'
require_relative 'scrum_lint/configuration'
require_relative 'scrum_lint/configurator'
require_relative 'scrum_lint/runner'

require_relative 'scrum_lint/models/card'
require_relative 'scrum_lint/models/list'
require_relative 'scrum_lint/models/board'

require_relative 'scrum_lint/checkers/context_checker'

# Namespace for all `ScrumLint` code
module ScrumLint
  def self.config
    @config ||= ScrumLint::Configuration.new
  end
end
