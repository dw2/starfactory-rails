class PasswordResetsController < ApplicationController

  def new
    @user = User.new
    add_breadcrumb 'Reset Password'
  end

  def create
    @user = User.find_by_email(params[:email])
    @user.deliver_reset_password_instructions! if @user
    add_breadcrumb 'Reset Password'
    redirect_to root_path, notice: 'Instructions have been sent to your email.'
  end

  def edit
    @user = User.load_from_reset_password_token(params[:id])
    @token = params[:id]
    add_breadcrumb 'New Password'

    if @user.blank?
      not_authenticated
      return
    end
  end

  def update
    @token = params[:token]
    @user = User.load_from_reset_password_token(params[:token])
    add_breadcrumb 'New Password'

    if @user.blank?
      flash[:error] = 'Unable to save password. Please contact us for further help.'
      not_authenticated
      return
    end

    if @user.change_password!(params[:user][:password])
      flash[:notice] = 'Your password was successfully changed. Please login.'
      redirect_to login_path
    else
      render action: 'edit'
    end
  end
end
