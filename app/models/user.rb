class User < ApplicationRecord
  ROLES = %w(user admin).freeze

  has_many :tasks, dependend: :destroy

  validates :email, presence: true
  validates :email, uniqueness: true, format: {with: /@/}, if: :email_changed?

  validates :password, presence: true, confirmation: true, if: :password_required?
  validates :password, length: {within: Rails.configuration.auth[:min_password_length]}, allow_blank: true

  validates :role, presence: true, inclusion: [in: ROLES]

  after_initialize :set_defaults

  private

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def set_defaults
    self.role = 'user' if role.blank?
  end

end
