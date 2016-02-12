require 'trello'
require 'colorize'
require 'byebug'

require_relative 'scrum_lint/configuration'
require_relative 'scrum_lint/runner'

module ScrumLint

  def self.config
    @config ||= ScrumLint::Configuration.new
  end

end
