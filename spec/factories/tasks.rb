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

require 'ffaker'

FactoryGirl.define do
  factory :task do
    user

    name { FFaker::Food.fruit }
    description { FFaker::HipsterIpsum.paragraph }
    state { Task.states[rand(Task.states.size)] }
  end
end
