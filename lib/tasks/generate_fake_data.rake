require 'ffaker'

namespace :generate do
  desc 'Generates fake tasks for different users'
  task :fake_data, [:number_of_users, :tasks_per_user] => :environment do |t, args|
    number_of_users = (args[:number_of_users] || 10).to_i
    tasks_per_user  = (args[:tasks_per_user]  || 10).to_i

    number_of_users.times do
      user = User.create!(email: FFaker::Internet.email,
                          password: FFaker::Internet.password)
      tasks_per_user.times do
        user.tasks.create(name: FFaker::Food.fruit,
                          description: FFaker::HipsterIpsum.paragraph,
                          state: Task.states[rand(Task.states.size)])
      end
    end
  end
end
