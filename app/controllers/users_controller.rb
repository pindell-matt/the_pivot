class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      flash[:error] = "Success! Your account updated."
    else
      flash[:error] = "Your account could not be updated. Please check your input and try again."
    end
      redirect_to dashboard_path
  end

  def create
    @user = User.new(user_params)
    if @user.save && current_user.host?
      host_role = Role.create(name: "host")
      @user.roles << host_role
      @user.home = current_user.home
      redirect_to dashboard_path
    elsif @user.save
      session[:user_id] = @user.id
      flash[:message] = "Logged in as #{@user.first_name}"
      @user.roles << Role.create(name:"registered_user")
      redirect_to dashboard_path
    else
      flash[:action] = "login unsuccesful"
      render :new
    end
  end

  def show
    if current_user.host?
      @home = current_user.home
    end
  end

  def index
    @users = User.all
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
