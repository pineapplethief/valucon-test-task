module CapybaraHelpers
  def ensure_path(path)
    visit(path) unless current_path == path
  end

  def submit_form(element_or_selector = nil, input_name: 'commit')
    receiver = element_or_selector ? element_or_selector : self
    input_selector = "input[name='#{input_name}']"
    receiver.find(input_selector).click
  end

  def user_signed_in?
    first('.qa-sign-out-link').present?
  end

  def user_signed_out?
    first('.qa-sign-in-link').present?
  end

  def sign_user_out!
    return unless user_signed_in?
    sign_out_link = find('.qa-sign-out-link')
    sign_out_link.click
  end

  def sign_user_in(user)
    return if user_signed_in?
    sign_in_link = find('.qa-sign-in-link')
    sign_in_link.click
  end

  def submit_sign_in_form(email:, password:)
    within find('.qa-sign-in-form') do
      fill_in 'Email',    with: email
      fill_in 'Password', with: password

      submit_form
    end
  end

  def create_and_sign_in_user(email:, password:)
    User.create!(email: email, password: password)
    ensure_path new_user_sign_in_path
    submit_sign_in_form(email: email, password: password)
  end
end
