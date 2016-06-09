RSpec.describe ScrumLint::Linter::MissingContext, '#call' do
  let(:checker) { described_class.new }

  it 'prints out cards that are missing contexts' do
    allow(Launchy).to receive(:open)
    list = fake_trello_list
    url = 'foo/bar/butts'
    card = fake_trello_card(name: 'bar card', desc: 'no context', url: url, list: list)
    allow(checker).to receive(:puts)
    checker.(card)
    card_message = "#{'bar card'.color(:blue)} has missing Context"
    expect(checker).to have_received(:puts).with(card_message)
  end

  it 'prints nothing when card is not missing context' do
    card = fake_trello_card(name: 'foo card', desc: 'Context: what')
    allow(checker).to receive(:puts)
    checker.(card)
    expect(checker).not_to have_received(:puts)
  end
end
