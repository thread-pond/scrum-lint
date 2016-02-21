require_relative 'support/coverage'
require_relative 'support/fake_builders'
require_relative '../lib/scrum_lint'

require 'webmock/rspec'

WebMock.disable_net_connect!(allow: 'codeclimate.com')

def spec_root
  File.dirname(__FILE__)
end

def fixture_path
  File.expand_path(File.join(spec_root, 'fixtures'))
end

RSpec.configure do |config|
  config.before(:suite) do
    config_file_path = './.scrum-lint.yml'
    unless File.exist?(config_file_path)
      fixture_file_path = File.join(fixture_path, 'scrum-lint.yml')
      File.write(config_file_path, File.read(fixture_file_path))
    end
  end
end
