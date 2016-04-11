RSpec.describe ScrumLint::Linter::MissingContext, '#call' do
  let(:checker) { described_class.new }

  it 'prints out cards that are missing contexts' do
    fake_valid_card = fake_trello_card(name: 'foo card', desc: 'Context: what')
    fake_invalid_card = fake_trello_card(name: 'bar card', desc: 'no context')
    cards = [fake_valid_card, fake_invalid_card]
    fake_list = fake_trello_list(name: 'Doing', cards: cards)
    fake_board = fake_trello_board(lists: [fake_list])
    board = ScrumLint::Board.new(fake_board)
    allow(checker).to receive(:puts)
    checker.(board)
    list_message = "List #{'Doing'.color(:green)} has cards missing context:"
    card_message = "-> #{'bar card'.color(:blue)}"
    expect(checker).to have_received(:puts).with(list_message)
    expect(checker).to have_received(:puts).with(card_message)
  end
end
