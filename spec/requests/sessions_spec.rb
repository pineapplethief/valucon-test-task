require "rails_helper"

RSpec.describe 'Authentication', type: :request, focus: true do
  let(:email) { 'user@example.com' }
  let(:password) { 'password' }
  before do
    User.create!(email: email, password: password)
  end

  context 'when email and password are correct' do
    it 'signs user in and redirect to user tasks' do
      get user_sign_in_path

      expect(response).to redirect_to(dashboard_tasks_path)
      follow_redirect!

      expect(response.body).to include(t(:signed_in))
    end
  end

  context 'when email is wrong' do
    it 're-renders sign in form and shows error' do
      post user_sign_in_path, params: {user: {email: 'non-existing-user@example.com', password: password}}

      puts "response = #{response.body.inspect}"

      expect(response).to render_template(:new)
      expect(response.body).to include(t(:wrong_email_or_password))
    end
  end

  context 'when email is correct but password is wrong' do
    it 're-renders sign in form and shows error' do
      post user_sign_in_path, params: {user: {email: email, password: 'wrong-password'}}

      expect(response).to render_template(:new)
      expect(response.body).to include(t(:wrong_email_or_password))
    end
  end
end
