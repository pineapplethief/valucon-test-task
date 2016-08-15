RSpec.describe 'Authentication', type: :feature do
  let(:email)    { 'user@example.com' }
  let(:password) { 'password' }

  context 'when user is not signed in' do
    before do
      user = User.create!(email: email, password: password)

      ensure_path new_user_sign_in_url
    end

    scenario 'It redirects to user dashboard when email and password are correct' do
      submit_sign_in_form(email: email, password: password)

      expect(page).to have_text t(:signed_in)
      expect(current_path).to eq dashboard_root_path
    end

    scenario 'It shows an error when email is wrong' do
      submit_sign_in_form(email: 'non-existing-user@example.com', password: password)

      expect(page).to have_text t(:wrong_email_or_password)
      expect(current_path).to eq user_sign_in_path
    end

    scenario 'It shows an error when email is correct but password is wrong' do
      submit_sign_in_form(email: email, password: 'wrong-password')

      expect(page).to have_text t(:wrong_email_or_password)
      expect(current_path).to eq user_sign_in_path
    end

  end

  context 'when user is signed in' do
    before do
      create_and_sign_in_user(email: email, password: password)
    end

    scenario 'when user signs out he is successfully signed out and is redirected to site root' do
      sign_user_out!

      expect(page).to have_content t(:signed_out)
      expect(current_path).to eq root_path
      expect(user_signed_out?).to be true
    end
  end

end
