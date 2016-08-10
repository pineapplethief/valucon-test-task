module Web
  class BaseController < ApplicationController
    helper_method :current_user
    helper_method :user_signed_in?

    protected

    def authenticate_user!
      unless user_signed_in?
        flash[:alert] = t(:not_authenticated)
        redirect_to new_user_sign_in_path
      end
    end

    def current_user
      if session[:current_user_id].present?
        User.find(session[:current_user_id])
      else
        # I really hate devise cause by default it returns nil if user is not found,
        # leading to endless current_user.try(:method) all over the project
        User.guest
      end
    end

    def user_signed_in?
      !current_user.guest?
    end

  end
end
