RSpec.describe ScrumLint::Linter::ExtraList, '#call' do
  let(:validator) { described_class.new }

  it 'prints a warning when the board has unexpected lists' do
    lists = [fake_trello_list, fake_trello_list(name: 'what list')]
    board = ScrumLint::Board.new(lists: lists, name: 'wat', url: 'who')
    allow(validator).to receive(:warn)
    validator.(board)
    message = 'extra lists found: ["what list"]'
    expect(validator).to have_received(:warn).with(message)
  end
end
