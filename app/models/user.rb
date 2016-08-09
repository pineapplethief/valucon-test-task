# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  password   :string           not null
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ApplicationRecord
  ROLES = %w(user admin).freeze

  has_many :tasks, dependent: :destroy

  validates :email, presence: true
  validates :email, uniqueness: true, format: {with: /@/}, if: :email_changed?

  with_options if: :password_required? do
    validates :password, presence: true, confirmation: true
    validates :password, length: {within: Rails.configuration.auth[:password_lengths]}, allow_blank: true
  end

  validates :role, presence: true, inclusion: {in: ROLES}

  after_initialize :set_defaults

  private

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def set_defaults
    self.role = 'user' unless role?
  end

end
