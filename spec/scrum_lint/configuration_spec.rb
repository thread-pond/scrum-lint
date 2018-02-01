RSpec.describe ScrumLint::Configuration do
  let(:configuration) { described_class.new }

  describe '#initialize' do
    it 'sets up default configurations' do
      expect(configuration.board_names).to eq ['Eng: Current']
    end

    it 'aborts when config file is missing' do
      file_path = ENV.fetch('config_file_path')
      allow(File).to receive(:exist?).with(file_path).and_return(false)
      message = /Please add a "\.scrum-lint\.yml" file/i
      expect { described_class.new }.to raise_error(SystemExit, message)
    end
  end
end
