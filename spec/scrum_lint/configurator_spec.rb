RSpec.describe ScrumLint::Configurator, '#call' do
  let(:configurator) { described_class.new }

  it 'configures the Trello gem' do
    fake_config = instance_double(Trello::Configuration).as_null_object
    allow(Trello).to receive(:configure).and_yield(fake_config)
    configurator.()
    the_key = ScrumLint.config.trello_developer_public_key
    the_token = ScrumLint.config.trello_member_token
    expect(fake_config).to have_received(:developer_public_key=).with(the_key)
    expect(fake_config).to have_received(:member_token=).with(the_token)
  end
end
