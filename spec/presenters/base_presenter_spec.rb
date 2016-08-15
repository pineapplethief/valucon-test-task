RSpec.describe BasePresenter do
  let(:model) { create(:task) }
  let(:view_context) { ActionController::Base.new.view_context }

  subject(:presenter) { described_class.new(model, view_context) }

  describe '.model_name' do
    it 'returns same model_name as model class' do
      expect(TaskPresenter.model_name).to eq(Task.model_name)
    end
  end

  describe 'method delegation' do
    it 'delegates methods existing on the model to id' do
      expect(model).to receive(:started?)

      presenter.started?
    end
  end

  describe '#h' do
    it 'returns view_context' do
      expect(presenter.h).to eq(view_context)
    end
  end

  describe '#instance_of?' do
    it 'uses model class to do comparison' do
      expect(presenter.instance_of?(Task)).to be true
    end
  end

  describe '#==' do
    context 'when other is wrapped in presenter' do
      let(:other) { TaskPresenter.new(create(:task), view_context) }

      it 'compares both object models' do
        expect(presenter.model).to receive(:==).with(other.model)

        presenter == other
      end
    end

    context 'when other is ordinary model' do
      let(:other) { double(Task) }

      it 'compares model to the other' do
        expect(presenter.model).to receive(:==).with(other)

        presenter == other
      end
    end
  end

end
