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

class Task < ApplicationRecord
  include AASM

  STATES = %w( new started finished ).freeze

  aasm column: :state, whiny_transitions: false do
    state :new, initial: true
    state :started
    state :finished

    event :start do
      transitions from: :new, to: :started
    end

    event :reset do
      transitions from: [:started, :finished], to: :new
    end

    event :finish do
      transitions from: :started, to: :finished
    end
  end

  mount_uploader :file, TaskFileUploader

  belongs_to :user

  validates :name, presence: true
  validates :state, presence: true

  scope :ordered, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(user: user) }

end
