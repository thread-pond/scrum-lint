def fake_trello_card(name: 'What card', desc: 'some desc', **options)
  instance_double(
    Trello::Card,
    name: name,
    desc: desc,
    card_labels: 'abc123',
    short_url: 'https://foo.bar.baz.biz',
    url: 'https://something.much.longer',
    **options
  )
end

def fake_trello_list(name: 'Planned', cards: [fake_trello_card])
  instance_double(Trello::List, name: name, cards: cards)
end

def fake_trello_board(name: 'Eng: Current', lists: [fake_trello_list])
  instance_double(Trello::Board, name: name, lists: lists, url: '', labels: [])
end
