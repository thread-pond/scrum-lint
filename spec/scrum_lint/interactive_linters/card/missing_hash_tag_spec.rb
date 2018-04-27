RSpec.describe ScrumLint::InteractiveLinter::MissingHashTag, '#call' do
  let(:checker) { described_class.new }
  let(:mock_reporter) do
    instance_double(ScrumLint::Reporters::InteractiveReporter)
  end
  let(:trello_card) { fake_trello_card(name: '#Eat pineapple') }
  let(:trello_list) { fake_trello_list(cards: [trello_card]) }
  let(:trello_board) { fake_trello_board(lists: [trello_list]) }
  let(:card) do
    ScrumLint::Trello::CardMapper.(
      trello_card,
      list: trello_list,
      board_name: trello_board.name
    )
  end

  before do
    allow(mock_reporter).to receive(:fail)
    allow(mock_reporter).to receive(:get_value)
  end

  it 'returns nil if card already has a hashtag' do
    result = checker.(card, reporter: mock_reporter)

    expect(result).to be_nil
    expect(mock_reporter).not_to have_received(:fail)
  end

  context 'when card does not have a hashtag' do
    let(:trello_card) { fake_trello_card(name: 'ice cream') }

    it 'shows a message' do
      checker.(card, reporter: mock_reporter)

      expect(mock_reporter).to have_received(:fail)
        .with(card, 'missing hashtag')
    end

    it 'assigns all of the hashtags to the card' do
      allow(mock_reporter).to receive(:get_value).and_yield('ScreamFor Eat buy')
      allow(trello_card).to receive(:name=)

      checker.(card, reporter: mock_reporter)

      expect(mock_reporter).to have_received(:get_value)
      expect(trello_card).to have_received(:name=)
        .with('#ScreamFor #Eat #buy ' + card.name)
      expect(card.hashtags).to match_array %w[#ScreamFor #Eat #buy]
    end
  end
end
