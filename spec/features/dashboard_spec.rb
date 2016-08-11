# В этом списке выводятся задачи со следующими
# атрибутами: идентификатор задачи, название, описание, статус задачи, время
# создания.

# Если пользователь - admin, то в списке задач в личном кабинете он видит все
# задачи в системе. При этом в таблице списка задач указывается ещё
# пользователь, на которого назначена задача. Он может назначать,
# редактировать и удалять задачи других пользователей.

RSpec.describe 'User Dashboard' do
  context 'when user is not an admin' do
    let(:user) { create_and_sign_in_user }

    scenario 'he can see only his tasks' do
      generate_fake_data(number_of_users: 3, tasks_per_user: 3)

      3.times { create(:task, user: user) }

      visit dashboard_root_path

      expect(page).to have_css('.qa-task', count: 3)
    end

    scenario 'each task is displayed with id, time when it was created, name, description and current state' do
      task = create(:task, name: 'Task name', description: 'Lorem Ipsum', state: 'new', user: user)

      visit dashboard_root_path

      task_element = find('.qa-task')
      expect(task_element).to have_css('.qa-task-id', text: /#{task.id}{1}/)
      expect(task_element).to have_css('.qa-task-created_at', text: l(task.created_at))
      expect(task_element).to have_css('.qa-task-state', text: t("task.states.#{task.state}"))
      expect(task_element).to have_css('.qa-task-name', text: task.name)
      expect(task_element).to have_css('.qa-task-description', text: task.description)
    end
  end

  context 'when user is an admin' do
    let(:user) { create_and_sign_in_user(role: 'admin') }

    scenario 'he can see all user tasks' do
      puts "user = #{user.inspect}"
      generate_fake_data(number_of_users: 3, tasks_per_user: 3)
      3.times { create(:task, user: user) }

      visit dashboard_root_path

      expect(page).to have_css('.qa-task', count: 12)
    end

    scenario 'each task is displayed with usual info plus whom this task is assigned to' do
      task = create(:task, user: user)

      visit dashboard_root_path

      task_element = find('.qa-task')

      expect(task_element).to have_css('.qa-task-id', text: /#{task.id}{1}/)
      expect(task_element).to have_css('.qa-task-created_at', text: l(task.created_at))
      expect(task_element).to have_css('.qa-task-state', text: t("task.states.#{task.state}"))
      expect(task_element).to have_css('.qa-task-name', text: task.name)
      expect(task_element).to have_css('.qa-task-description', text: task.description)
      expect(task_element).to have_css('.qa-task-user', text: user.to_s)
    end
  end

end
