RSpec.describe ScrumLint::Board do
  let(:fake_done_list) { fake_trello_list(name: 'Done Stuff') }
  let(:fake_task_list) { fake_trello_list(name: 'This Sprint') }
  let(:lists) { [fake_done_list, fake_task_list] }
  let(:board_params) { { url: '', name: '', context: {} } }
  let(:board) { described_class.new(board_params.merge(lists: lists)) }

  describe '#lists' do
    it 'returns all of the lists for the board' do
      expect(board.lists.map(&:name)).to eq ['Done Stuff', 'This Sprint']
    end
  end

  describe '#done_lists' do
    it 'returns the done lists for the board' do
      expect(board.done_lists.map(&:name)).to eq ['Done Stuff']
    end
  end

  describe '#task_lists' do
    it 'returns the task lists for the board' do
      expect(board.task_lists.map(&:name)).to eq ['This Sprint']
    end
  end
end
