require 'factory_girl_rails'

module FakeDataGenerator
  extend self

  def generate_fake_data(number_of_users: 5, tasks_per_user: 5)
    number_of_users.times do
      user = FactoryGirl.create(:user)
      tasks_per_user.times do
        FactoryGirl.create(:task, user: user)
      end
    end
  end
end
