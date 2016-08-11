RSpec.describe 'Tasks index page on site root' do
  context 'when user navigates to the site root' do
    context 'and there are tasks by different users' do
      before do
        generate_fake_data(number_of_users: 3, tasks_per_user: 3)
      end

      scenario 'he can view list of all tasks in the system' do
        visit root_path

        expect(page).to have_css('.qa-task', count: 9)
      end
    end

    scenario 'each task is displayed with id, time when it was created, name and user assigned' do
      user = create(:user)
      task = create(:task, name: 'Task name', description: 'Lorem Ipsum', state: 'new', user: user)

      visit root_path

      task_element = first('.qa-task')

      expect(task_element).to have_css('.qa-task-id', text: /#{task.id}{1}/)
      expect(task_element).to have_css('.qa-task-created_at', text: l(task.created_at))
      expect(task_element).to have_css('.qa-task-name', text: task.name)
      expect(task_element).to have_css('.qa-task-user', text: user.to_s)
    end
  end

end
