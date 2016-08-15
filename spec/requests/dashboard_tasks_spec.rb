RSpec.describe 'Dashboard Tasks CRUD', type: :request do
  context 'given user is not an admin' do
    let(:password) { 'password' }
    let!(:user) { create(:user, password: password) }

    before(:each) do
      login_user(user: user, password: password)
    end

    describe 'GET /tasks/new' do
      it 'renders ok' do
        get '/dashboard/tasks/new'

        expect(response).to be_success
      end
    end

    describe 'POST /tasks' do
      context 'when task params are correct' do
        let(:task_params) { {task: attributes_for(:task, user_id: user.id)} }

        it 'renders success message and redirects' do
          post '/dashboard/tasks', params: task_params

          expect(response).to redirect_to('/dashboard')
          expect(flash[:notice]).to eq(t(:task_created))
        end
      end

      context 'when task params are not correct' do
        let(:task_params) { {task: attributes_for(:task, name: nil, user_id: user.id)} }

        it 'it returns unprocessable_entity status' do
          post '/dashboard/tasks', params: task_params

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'GET /tasks/:id' do
      context 'and when user owns this task' do
        let(:task) { create(:task, user: user) }

        it 'returns OK' do
          get "/dashboard/tasks/#{task.id}"

          expect(response).to be_success
        end
      end

      context "and when user doesn't own this task" do
        let(:task) { create(:task, user: create(:user)) }

        it 'returns :forbidden status' do
          get "/dashboard/tasks/#{task.id}"

          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    describe 'GET /tasks/:id/edit' do
      context 'and when user owns this task' do
        let(:task) { create(:task, user: user) }

        it 'renders OK' do
          get "/dashboard/tasks/#{task.id}/edit"

          expect(response).to be_success
        end
      end

      context "and when user doesn't own this task" do
        let(:task) { create(:task, user: create(:user)) }

        it 'returns :forbidden status' do
          get "/dashboard/tasks/#{task.id}/edit"

          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    describe 'PUT /tasks/:id' do
      context 'when user owns this task' do
        let(:task) { create(:task, user: user) }

        context 'and when task params are correct' do
          let(:task_params) { {task: attributes_for(:task, user_id: user.id)} }

          it 'redirects and shows task updated message' do
            put "/dashboard/tasks/#{task.id}", params: task_params

            expect(flash[:notice]).to eq(t(:task_updated))
            expect(response).to redirect_to('/dashboard')
          end
        end

        context 'and when task params are not correct' do
          let(:task_params) { {task: attributes_for(:task, name: nil, user_id: user.id)} }

          it 'it returns :unprocessable_entity status' do
            put "/dashboard/tasks/#{task.id}", params: task_params

            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end

      context "and when user doesn't own this task" do
        let(:task) { create(:task, user: create(:user)) }
        let(:task_params) { {task: attributes_for(:task, user: user)} }

        it 'returns :forbidden status' do
          put "/dashboard/tasks/#{task.id}", params: task_params

          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    describe 'GET /tasks/:id/download_attachment' do
      context 'when user owns this task' do
        let(:task) { create(:task, user: user, file: File.open(fixture_image_path)) }

        context 'and there is file uploaded for this task' do
          it 'sends file' do
            get "/dashboard/tasks/#{task.id}/download_attachment"

            expect(response.headers["Content-Transfer-Encoding"]).to eq('binary')
          end
        end

        context 'and there is NO file uploaded for this task' do
          let(:task) { create(:task, user: user) }

          it 'shows error and redirects' do
            get "/dashboard/tasks/#{task.id}/download_attachment"

            expect(flash[:error]).to eq(t(:uploaded_file_not_found))

            expect(response).to redirect_to(request.referrer || root_path)
          end
        end
      end

      context "and when user doesn't own this task" do
        let(:task) { create(:task, user: create(:user)) }

        it 'returns :forbidden status' do
          get "/dashboard/tasks/#{task.id}/download_attachment"

          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    describe 'DELETE /tasks/:id' do
      context 'when user owns this task' do
        let(:task) { create(:task, user: user) }

        it 'redirects and shows task deleted message' do
          delete "/dashboard/tasks/#{task.id}"

          expect(flash[:notice]).to eq(t(:task_destroyed))
          expect(response).to redirect_to('/dashboard')
        end
      end

      context "when user doesn't own this task" do
        let(:task) { create(:task, user: create(:user)) }

        it 'returns :forbidden status' do
          delete "/dashboard/tasks/#{task.id}"

          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    describe 'PUT /dashboard/tasks/:id/change_state' do
      context 'when user owns this task' do
        let(:task) { create(:task, user: user, state: 'new') }

        context 'when event is defined' do
          context 'and when event is allowed' do
            let(:event) { 'start' }

            it 'returns json with new state' do
              put "/dashboard/tasks/#{task.id}/change_state", params: {event: event}

              expect(json[:status]).to eq(t('task.states.started'))
            end
          end

          context 'and when event is not allowed' do
            let(:event) { 'finish' }

            it 'returns json with error' do
              put "/dashboard/tasks/#{task.id}/change_state", params: {event: event}

              expect(json).to have_key(:error)
            end
          end
        end

        context 'when event is not defined' do
          let(:event) { 'strange_brew' }
          it 'returns json with error' do
            put "/dashboard/tasks/#{task.id}/change_state", params: {event: event}

            expect(json).to have_key(:error)
          end
        end
      end

      context "when user doesn't own this task" do
        let(:task) { create(:task, user: create(:user)) }

        it 'returns :forbidden status' do
          put "/dashboard/tasks/#{task.id}/change_state"

          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  context 'given user is an admin' do
    let(:password) { 'password' }
    let!(:admin) { create(:user, password: password, role: 'admin') }

    before(:each) do
      login_user(user: admin, password: password)
    end

    describe 'POST /tasks' do
      context 'admin can create tasks for other users' do
        let(:user) { create(:user) }
        let(:task_params) { {task: attributes_for(:task, user_id: user.id)} }

        it 'renders success message and redirects' do
          post '/dashboard/tasks', params: task_params

          expect(response).to redirect_to('/dashboard')
          expect(flash[:notice]).to eq(t(:task_created))
        end
      end
    end

    describe 'GET /tasks/:id' do
      context "and when admin doesn't own this task" do
        let(:task) { create(:task, user: create(:user)) }

        it 'returns OK' do
          get "/dashboard/tasks/#{task.id}"

          expect(response).to be_success
        end
      end
    end

    describe 'GET /tasks/:id/edit' do
      context "and when admin doesn't own this task" do
        let(:task) { create(:task, user: create(:user)) }

        it 'returns OK' do
          get "/dashboard/tasks/#{task.id}/edit"

          expect(response).to be_success
        end
      end
    end

    describe 'PUT /tasks/:id' do
      context "and when admin doesn't own this task" do
        let(:task) { create(:task, user: create(:user)) }
        let(:task_params) { {task: attributes_for(:task, user: admin)} }

        it 'redirects and shows task updated message' do
          put "/dashboard/tasks/#{task.id}", params: task_params

          expect(flash[:notice]).to eq(t(:task_updated))
          expect(response).to redirect_to('/dashboard')
        end
      end
    end

    describe 'DELETE /tasks/:id' do
      context "when admin doesn't own this task" do
        let(:task) { create(:task, user: create(:user)) }

        it 'returns :forbidden status' do
          delete "/dashboard/tasks/#{task.id}"

          expect(flash[:notice]).to eq(t(:task_destroyed))
          expect(response).to redirect_to('/dashboard')
        end
      end
    end

  end
end
