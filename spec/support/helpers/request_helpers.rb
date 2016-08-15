module RequestHelpers
  def login_user(user:, password: 'password')
    post '/sign_in', params: {
      user: {
        email: user.email,
        password: password
      }
    }
  end
end
