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
  STATES = %w( new started finished ).freeze

  mount_uploader :file, TaskFileUploader

  belongs_to :user

  validates :name, presence: true
  validates :state, presence: true, inclusion: {in: STATES}

  scope :ordered, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(user: user) }

  after_initialize :set_defaults

  def self.states
    STATES
  end

  private

  def set_defaults
    self.state = 'new' unless state?
  end
end
