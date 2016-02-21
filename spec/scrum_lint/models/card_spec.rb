RSpec.describe ScrumLint::Card do
  let(:fake_card) { fake_trello_card(name: 'what name', desc: 'what desc') }
  let(:card) { described_class.new(fake_card, list: fake_trello_list) }

  describe '#desc' do
    it 'returns the card description' do
      expect(card.desc).to eq 'what desc'
    end
  end

  describe '#name' do
    it 'returns the card name' do
      expect(card.name).to eq 'what name'
    end
  end
end
