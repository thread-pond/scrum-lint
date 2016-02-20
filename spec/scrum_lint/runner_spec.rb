RSpec.describe ScrumLint::Runner, '#call' do
  let(:runner) { described_class.new }

  before(:each) do
    allow(Trello::Board).to receive(:all).and_return([fake_trello_board])
  end

  it 'configures trello settings' do
    allow(ScrumLint::Configurator).to receive(:call).and_call_original
    runner.()
    expect(ScrumLint::Configurator).to have_received(:call)
  end

  it 'validates the selected board' do
    allow(ScrumLint::BoardValidator).to receive(:call).and_call_original
    runner.()
    expect(ScrumLint::BoardValidator).to have_received(:call)
      .with(instance_of(ScrumLint::Board))
  end

  it 'checks contexts' do
    allow(ScrumLint::ContextChecker).to receive(:call).and_call_original
    runner.()
    expect(ScrumLint::ContextChecker).to have_received(:call)
      .with(instance_of(ScrumLint::Board))
  end
end
