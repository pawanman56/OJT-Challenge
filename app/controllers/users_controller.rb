class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correcet_user, only: [:edit, :update]

  def index
    @users = User.order('created_at DESC').all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      @user.send_activation_email
      flash[:success] = "Please check your email to activate your account."
      redirect_to root_url
    else
      flash[:danger] = "Oops! Something went wrong"
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated successfully!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correcet_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
