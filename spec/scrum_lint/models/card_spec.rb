RSpec.describe ScrumLint::Card do
  let(:card_params) do
    {
      checklists: nil,
      desc: nil,
      labels: nil,
      list: nil,
      short_url: nil,
      source: nil,
      url: nil,
    }
  end

  describe '#hashtags' do
    it 'returns the hashtags from the card name' do
      names = ['(12) #foo blah #bar', '#foo blah #bar', '#foo blah #bar [15]']
      names.each do |name|
        card = described_class.new(card_params.merge(name: name))
        expect(card.hashtags).to eq ['#foo', '#bar']
      end
    end

    it 'returns an empty array when the card name has no hashtags' do
      card = described_class.new(card_params.merge(name: '(12) blah [15]'))
      expect(card.hashtags).to eq []
    end
  end

  describe '#task_text' do
    it 'returns the task text from the card name' do
      names = ['(12) #foo blah #bar', '#foo blah #bar']
      names.each do |name|
        card = described_class.new(card_params.merge(name: name))
        expect(card.task_text).to eq 'blah'
      end
    end

    it 'returns an empty string when the card has no task text' do
      card = described_class.new(card_params.merge(name: '(12) #blah'))
      expect(card.task_text).to eq ''
    end
  end

  describe '#point_count' do
    it 'returns the task point count' do
      names = ['(12) #foo blah #bar', 'what (12) what', '#foo blah #bar (12)']
      names.each do |name|
        card = described_class.new(card_params.merge(name: name))
        expect(card.point_count).to eq 12
      end
    end

    it 'returns nil when there is no point count' do
      card = described_class.new(card_params.merge(name: '#foo blah #bar'))
      expect(card.point_count).to be_nil
    end
  end
end
