module ScrumLint
  RSpec.describe Runner, '#call' do
    let(:runner) { described_class.new }

    before(:each) do
      allow(::Trello::Board).to receive(:all).and_return([fake_trello_board])
    end

    it 'configures trello settings' do
      allow(Configurator).to receive(:call).and_call_original
      runner.([])
      expect(Configurator).to have_received(:call)
    end

    it 'validates the selected board' do
      allow(Linter::MissingTaskList).to receive(:call).and_call_original
      allow(Linter::ExtraList).to receive(:call).and_call_original
      runner.([])
      expect(Linter::MissingTaskList).to have_received(:call)
        .with(instance_of(Board))
      expect(Linter::ExtraList).to have_received(:call).with(instance_of(Board))
    end

    it 'checks contexts' do
      allow(Linter::MissingContext).to receive(:call).and_call_original
      runner.([])
      expect(Linter::MissingContext).to have_received(:call)
        .with(instance_of(Board))
    end
  end
end
