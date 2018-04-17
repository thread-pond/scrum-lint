module ScrumLint
  RSpec.describe Runner, '#call' do
    let(:runner) { described_class.new }

    before do
      allow(Launchy).to receive(:open)

      allow(::Trello::Board).to receive(:all).and_return([fake_trello_board])
      allow(::Trello::Card).to receive(:find).and_return(fake_trello_card)

      allow(Octokit::Source).to receive(:call).and_return([])
    end

    it 'configures trello settings' do
      allow(Configurator).to receive(:call).and_call_original
      runner.([])
      expect(Configurator).to have_received(:call)
    end

    it 'validates the selected board' do
      allow(Linter::ExtraList).to receive(:call).and_call_original
      allow(Linter::ExtraDoneList).to receive(:call).and_call_original
      allow(Linter::MissingTaskList).to receive(:call).and_call_original
      runner.([])
      expect(Linter::ExtraList).to have_received(:call)
        .with(instance_of(Board))
      expect(Linter::ExtraDoneList).to have_received(:call)
        .with(instance_of(Board))
      expect(Linter::MissingTaskList).to have_received(:call)
        .with(instance_of(Board))
    end

    describe 'card linters' do
      it 'runs for cards with "task" and "active" tags' do
        allow(Linter::MissingHashTag).to receive(:call).and_call_original
        allow(Linter::MissingContext).to receive(:call).and_call_original
        allow(Linter::MissingExpendedPoints).to receive(:call)
        runner.([])
        expect(Linter::MissingHashTag).to have_received(:call)
          .with(instance_of(Card))
        expect(Linter::MissingContext).to have_received(:call)
          .with(instance_of(Card))
        expect(Linter::MissingExpendedPoints).not_to have_received(:call)
      end

      it 'runs for cards with "task" and "done" tags' do
        allow(ScrumLint::CardTagger).to receive(:call)
          .and_return(%i[task done])
        allow(Linter::MissingHashTag).to receive(:call).and_call_original
        allow(Linter::MissingContext).to receive(:call)
        allow(Linter::MissingExpendedPoints).to receive(:call).and_call_original
        runner.([])
        expect(Linter::MissingHashTag).to have_received(:call)
          .with(instance_of(Card))
        expect(Linter::MissingContext).not_to have_received(:call)
        expect(Linter::MissingExpendedPoints).to have_received(:call)
          .with(instance_of(Card))
      end

      it 'runs for cards with "task" tags' do
        allow(ScrumLint::CardTagger).to receive(:call).and_return([:task])
        allow(Linter::MissingHashTag).to receive(:call).and_call_original
        allow(Linter::MissingContext).to receive(:call)
        allow(Linter::MissingExpendedPoints).to receive(:call)
        runner.([])
        expect(Linter::MissingHashTag).to have_received(:call)
          .with(instance_of(Card))
        expect(Linter::MissingContext).not_to have_received(:call)
        expect(Linter::MissingExpendedPoints).not_to have_received(:call)
      end

      it 'runs no linters for cards with "project" tags' do
        allow(ScrumLint::CardTagger).to receive(:call).and_return([:project])
        allow(Linter::MissingHashTag).to receive(:call)
        allow(Linter::MissingContext).to receive(:call)
        allow(Linter::MissingExpendedPoints).to receive(:call)
        runner.([])
        expect(Linter::MissingHashTag).not_to have_received(:call)
          .with(instance_of(Card))
        expect(Linter::MissingContext).not_to have_received(:call)
        expect(Linter::MissingExpendedPoints).not_to have_received(:call)
      end
    end
  end
end
