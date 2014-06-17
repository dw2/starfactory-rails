class UsersController < ApplicationController
  respond_to :html

  before_action :load_user, only: [:edit, :update, :destroy]

  def new
    @page_title = 'Register'
    @user = User.new
    add_breadcrumb 'Register'
  end

  def edit
    @page_title = 'Edit'
    add_breadcrumb 'Users', admin_users_url
    add_breadcrumb @user.name
  end
    
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url
    end
    add_breadcrumb 'Register'
    respond_with @user
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "#{@user.name} saved."
    end
    respond_with @user, location: admin_users_url, error: 'Unable to update user.'
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
