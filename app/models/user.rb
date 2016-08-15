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
  ROLES = %w(guest user admin).freeze

  has_secure_password

  has_many :tasks, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :email, format: {with: /@/}, if: :email_changed?

  validates :role, presence: true, inclusion: {in: ROLES}

  after_initialize :set_guest
  before_create :set_defaults

  def self.roles
    ROLES
  end

  def self.guest
    new(role: 'guest')
  end

  def guest?
    role == 'guest'
  end

  def user?
    role == 'user'
  end

  def admin?
    role == 'admin'
  end

  def to_s
    email
  end

  private

  def set_guest
    self.role = 'guest' unless role?
  end

  def set_defaults
    self.role = 'user' if guest?
  end

end
