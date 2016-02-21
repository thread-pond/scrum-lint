RSpec.describe ScrumLint::List do
  let(:fake_card_1) { fake_trello_card(name: 'one name') }
  let(:fake_card_2) { fake_trello_card(name: 'two name') }
  let(:fake_cards) { [fake_card_1, fake_card_2] }
  let(:fake_list) { fake_trello_list(name: 'a list', cards: fake_cards) }
  let(:list) { described_class.new(fake_list) }

  describe '#name' do
    it 'returns the name of the list' do
      expect(list.name).to eq 'a list'
    end
  end

  describe '#cards' do
    it 'returns the associated cards' do
      expect(list.cards.map(&:name)).to eq ['one name', 'two name']
      expect(list.cards.map(&:list).uniq).to eq [list]
    end
  end
end
