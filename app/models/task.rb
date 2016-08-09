class Task < ApplicationRecord
  STATES = %w( new started finished ).freeze
  belongs_to :user

  validates :name, presence: true
  validates :state, presence: true, inclusion: [in: STATES]
end
