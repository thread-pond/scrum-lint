RSpec.describe ScrumLint::Configuration do
  let(:configuration) { described_class.new }

  describe '#initialize' do
    it 'sets up default configurations' do
      expect(configuration.board_names).to eq ['Eng: Current']
    end

    it 'aborts when .scrum-lint.yml is missing' do
      file_path = './.scrum-lint.yml'
      allow(File).to receive(:exist?).with(file_path).and_return(false)
      message = /Please add a "\.scrum-lint\.yml" file/i
      expect { described_class.new }.to raise_error(SystemExit, message)
    end
  end
end
