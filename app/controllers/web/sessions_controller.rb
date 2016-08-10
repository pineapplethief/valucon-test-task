module Web
  class SessionsController < BaseController
    def new
      @user = User.new
    end

    def create
      @user = User.find_by(email: user_params[:email])
      if @user && @user.authenticate(user_params[:password])
        session[:current_user_id] = @user.id
        redirect_to root_path
      else
        @user = User.new
        flash[:alert] = t(:wrong_email_or_password)
        render :new
      end
    end

    def destroy
      session[:current_user_id] = nil
      flash[:notice] = t(:signed_out)
      redirect_to root_path
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end

  end
end
