module Web
  class BaseController < ApplicationController
    helper_method :current_user
    helper_method :user_signed_in?
    helper_method :sign_in
    helper_method :present

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

    def sign_in(user)
      return if user.guest?
      session[:current_user_id] = @user.id
      flash[:notice] = t(:signed_in)
    end

    def present(model_or_collection, presenter_class = nil)
      return model_or_collection.map { |model| present(model) } if model_or_collection.respond_to?(:map)

      model = model_or_collection
      presenterless_model_class_name = model.class.to_s.gsub(/Presenter$/, '')
      klass = if presenter_class.present?
        presenter_class
      else
        "#{presenterless_model_class_name}Presenter".constantize
      end
      view_context = self.respond_to?(:view_context) ? self.view_context : self

      presenter = klass.new(model, view_context)

      block_given? ? yield(presenter) : presenter
    end

  end
end
