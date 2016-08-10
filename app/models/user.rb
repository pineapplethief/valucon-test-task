# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  role            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ApplicationRecord
  ROLES = %w(user admin).freeze

  has_secure_password

  has_many :tasks, dependent: :destroy

  validates :email, presence: true
  validates :email, uniqueness: true, format: {with: /@/}, if: :email_changed?

  validates :role, presence: true, inclusion: {in: ROLES}

  after_initialize :set_defaults

  def self.guest
    new
  end

  def guest?
    !persisted?
  end

  private

  def set_defaults
    self.role = 'user' unless role?
  end

end
