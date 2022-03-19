class UsersController < ApplicationController
 
  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.create!(user_params)
    if @user
      log_in @user
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end