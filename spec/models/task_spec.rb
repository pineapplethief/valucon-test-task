# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string           not null
#  description :text
#  state       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_tasks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_4d2a9e4d7e  (user_id => users.id)
#

RSpec.describe Task, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:state) }

  it { is_expected.to validate_inclusion_of(:state).in_array(described_class::STATES) }

  it { is_expected.to transition_from(:new).to(:started).on_event(:start) }
  it { is_expected.to transition_from(:started).to(:finished).on_event(:finish) }
  it { is_expected.to transition_from(:started).to(:new).on_event(:reset) }
  it { is_expected.to transition_from(:finished).to(:new).on_event(:reset) }

  context 'when task is new' do
    it { is_expected.to allow_event(:start) }
  end

  context 'when task is started' do
    subject { Task.new(state: 'started') }

    it { is_expected.to allow_event(:finish) }
    it { is_expected.to allow_event(:reset) }
  end

  context 'when task is finished' do
    subject { Task.new(state: 'finished') }

    it { is_expected.to allow_event(:reset) }
  end


end
