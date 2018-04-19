RSpec.describe ScrumLint::InteractiveLinter::MissingContext, '#call' do
  let(:checker) { described_class.new }
  let(:project_card) { fake_trello_card(name: '#Project', url: 'pro/ject') }
  let(:project_card_2) { fake_trello_card(name: '#Poopject', url: 'poop/ject') }
  let(:card) { fake_trello_card(name: '#Butts fart more', desc: 'nocontext') }

  before do
    allow(Launchy).to receive(:open)
    allow(card).to receive(:desc=)
  end

  context 'when there is no project card with matching hashtag' do
    before do
      # gets must have a mocked return value or the tests will pass every time
      allow(checker).to receive(:gets).and_return('2')
    end

    it 'prints list of project cards' do
      allow(checker).to receive(:puts).exactly(4).times
      allow(checker).to receive(:print)

      checker.(card, active_project_cards: [project_card, project_card_2])

      expect(checker).to have_received(:print).with('enter project number > ')
      expect(checker).to have_received(:puts).with('1. #Project')
      expect(checker).to have_received(:puts).with('2. #Poopject')
    end

    it 'adds a context link to the description of the chosen card' do
      checker.(card, active_project_cards: [project_card, project_card_2])

      expect(card).to have_received(:desc=)
        .with("Context: #{project_card_2.url}\n\n#{card.desc}")
    end

    it 'skips and prints message when an invalid option is chosen' do
      allow(checker).to receive(:gets).and_return('doodypoo')
      allow(checker).to receive(:puts).exactly(4).times

      checker.(card, active_project_cards: [project_card, project_card_2])

      expected_message = 'doodypoo is not a valid option. Skipping card; ' \
        'no context link added.'
      expect(card).not_to have_received(:desc=)
      expect(checker).to have_received(:puts).with(expected_message)
    end
  end

  context 'when there is a matching hashtag' do
    let(:project_card_2) { fake_trello_card(name: '#Butts', url: 'poo/butt') }

    it 'suggests a context link for that hashtag' do
      allow(checker).to receive(:print)
      allow(checker).to receive(:gets).and_return('')

      checker.(card, active_project_cards: [project_card, project_card_2])

      expect(checker).to have_received(:print)
        .with('Add context link for #Butts? (y/n) > ')
    end

    it 'applies the suggested context when user hits enter' do
      allow(checker).to receive(:gets).and_return('')

      checker.(card, active_project_cards: [project_card, project_card_2])

      expect(card).to have_received(:desc=)
        .with("Context: #{project_card_2.url}\n\n#{card.desc}")
    end

    it 'applies the suggested context when user enters "y"' do
      allow(checker).to receive(:gets).and_return('y')

      checker.(card, active_project_cards: [project_card, project_card_2])

      expect(card).to have_received(:desc=)
        .with("Context: #{project_card_2.url}\n\n#{card.desc}")
    end

    it 'prints the list of projects and applies chosen one when "n" entered' do
      allow(checker).to receive(:gets).and_return('n', '1')
      allow(checker).to receive(:puts).exactly(4).times
      allow(checker).to receive(:print).twice

      checker.(card, active_project_cards: [project_card, project_card_2])

      expect(checker).to have_received(:print).with('enter project number > ')
      expect(checker).to have_received(:puts).with('1. #Project')
      expect(checker).to have_received(:puts).with('2. #Butts')

      expect(card).to have_received(:desc=)
        .with("Context: #{project_card.url}\n\n#{card.desc}")
    end
  end

  context 'when the card already has a context link' do
    before do
      allow(checker).to receive(:gets).and_return('butt')
      allow(checker).to receive(:desc=)
    end

    it 'does nothing' do
      card = fake_trello_card(name: 'poop doop', desc: 'Context: fart/less')
      checker.(card, active_project_cards: [project_card, project_card_2])

      expect(checker).not_to have_received(:desc=)
      expect(checker).not_to have_received(:gets)
    end
  end

  context 'when there are no project cards' do
    before do
      allow(checker).to receive(:gets).and_return('butt')
      allow(checker).to receive(:desc=)
    end

    it 'does nothing' do
      card = fake_trello_card(name: 'poop doop', desc: 'talk less, fart more')
      checker.(card, active_project_cards: [])

      expect(checker).not_to have_received(:desc=)
      expect(checker).not_to have_received(:gets)
    end
  end
end
