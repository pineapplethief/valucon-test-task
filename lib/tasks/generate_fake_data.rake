unless Rails.env.production?
  require Rails.root.join('spec', 'support', 'helpers', 'fake_data_generator')

  namespace :generate do
    desc 'Generates fake data: users with tasks'
    task :fake_data, [:number_of_users, :tasks_per_user] => :environment do |t, args|
      number_of_users = (args[:number_of_users] || 5).to_i
      tasks_per_user  = (args[:tasks_per_user]  || 5).to_i

      FakeDataGenerator.generate_fake_data(number_of_users: number_of_users, tasks_per_user: tasks_per_user)
    end
  end
end
