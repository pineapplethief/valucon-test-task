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


RSpec.describe User, type: :model do
  it { is_expected.to have_many(:tasks).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:role) }
  it { is_expected.to validate_inclusion_of(:role).in_array(described_class::ROLES) }
  it { is_expected.to have_secure_password }

  context 'when email is changed' do
    subject { User.new(email: 'guest@example.net', password: 'qwerty123') }

    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to allow_value('guest@example.net').for(:email) }
    it { is_expected.not_to allow_value('guestexmaple.net').for(:email) }

  end

end
