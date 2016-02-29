RSpec.describe ScrumLint::Linter::ExtraList, '#call' do
  let(:validator) { described_class.new }

  it 'prints a warning when the board has unexpected lists' do
    fake_task_list = fake_trello_list
    fake_list = fake_trello_list(name: 'what list')
    fake_board = fake_trello_board(lists: [fake_task_list, fake_list])
    board = ScrumLint::Board.new(fake_board)
    allow(validator).to receive(:warn)
    validator.(board)
    message = 'extra lists found: ["what list"]'
    expect(validator).to have_received(:warn).with(message)
  end
end
