# coding: utf-8
require_relative 'lib/scrum_lint/version'

def exe_files
  `git ls-files exe`.split($RS).map { |f| File.basename(f) }
end

Gem::Specification.new do |spec|
  spec.name    = 'scrum_lint'
  spec.version = ScrumLint::VERSION
  spec.authors = ['Robert Fletcher']
  spec.email   = ['robert@chalkschools.com']

  spec.summary  = 'Toolkit to help manage a very specific Trello workflow'
  spec.homepage = 'https://github.com/ChalkSchools/scrum-lint'
  spec.license  = 'MIT'

  spec.files         = `git ls-files lib`.split($RS)
  spec.files         += %w(README.md LICENSE.txt CODE_OF_CONDUCT.md)
  spec.bindir        = 'exe'
  spec.executables   = exe_files
  spec.require_paths = %w(lib)

  spec.required_ruby_version = '>= 2.1'

  spec.add_dependency 'ruby-trello', '~> 1.4'
  spec.add_dependency 'colorize', '~> 0.7'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'byebug', '~> 8.2'
end
