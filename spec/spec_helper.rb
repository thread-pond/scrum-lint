require_relative 'support/coverage'
require_relative '../lib/scrum_lint'

require 'webmock/rspec'

WebMock.disable_net_connect!

def fake_trello_list(name: 'Planned', cards: [])
  instance_double(Trello::List, name: name, cards: cards)
end

def fake_trello_board(name: 'Eng: Current', lists: [fake_trello_list])
  instance_double(Trello::Board, name: name, lists: lists)
end
