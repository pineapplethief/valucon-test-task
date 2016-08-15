RSpec.describe ApplicationPolicy do
  let(:task) { build_stubbed(:task) }

  context 'when user is a guest' do
    let(:user) { build_stubbed(:user, role: 'guest') }

    it 'raises unathorized error' do
      expect { described_class.new(user, task) }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  context 'when user is not a guest' do
    let(:user) { build_stubbed(:user) }

    subject(:policy) { described_class.new(user, task) }

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:new) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:destroy) }

    describe '#scope' do
      let(:klass) { Task }

      context 'when record is wrapped in presenter' do
        let(:presented_task) { TaskPresenter.new(task, ActionController::Base.new.view_context) }

        subject(:policy) { described_class.new(user, presented_task) }

        it 'resolves proper record class' do
          expect(Pundit).to receive(:policy_scope!).with(user, klass)

          policy.scope
        end
      end

      context 'when recors is not wrapped in presenter' do

        it 'resolves proper record class' do
          expect(Pundit).to receive(:policy_scope!).with(user, klass)

          policy.scope
        end
      end
    end
  end

end
