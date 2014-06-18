class UsersController < ApplicationController
  respond_to :html

  before_action :load_user, only: [:edit, :update, :destroy]

  def new
    @page_title = 'Register'
    @user = User.new
    @user.student_profile = StudentProfile.new
    add_breadcrumb 'Register'
  end

  def edit
    @page_title = 'Edit'
    add_breadcrumb 'Users', admin_users_url
    add_breadcrumb @user.name
  end
    
  def create
    @user = policy_scope(User).new(user_params)
    if @user.save
      flash[:notice] = 'Thanks for registering. Check your email to confirm your new Starfactory account.'
      redirect_to root_url
    else
      add_breadcrumb 'Register'
      respond_with @user
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "#{@user.name} saved."
    end
    respond_with @user, location: admin_users_url, error: 'Unable to update user.'
  end

  def activate
    if @user = User.load_from_activation_token(params[:token])
      @user.activate!
      flash[:notice] = 'Your Starfactory account has been activated. Please login.'
      redirect_to login_path
    else
      not_authenticated
    end
  end

private
  def load_user
    @user = policy_scope(User).find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      *policy(@user || User).permitted_attributes
    )
  end
end
