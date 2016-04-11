RSpec.describe ScrumLint::Linter::MissingTaskList, '#call' do
  let(:validator) { described_class.new }

  it 'raises an error when the board has no task lists' do
    board = ScrumLint::Board.new(fake_trello_board(lists: []))
    expect do
      validator.(board)
    end.to raise_error(/no task lists found/i)
  end
end
