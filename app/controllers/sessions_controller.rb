class SessionsController < ApplicationController
  # include CurrentUserConcern

  def show
    render json: current_user
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      render json: {
        status: 200,
        logged_in: true,
        user: user
      }
    else
      render json: {
        status: 401,
        message: "Please enter correct username and password."
      }
    end
  end

  def logged_in
    if current_user
      render json: { 
        logged_in: true,
        user: @current_user
      }
    else
      render json: {
        logged_in: false
      }
    end
  end

  def logout
    reset_session
    render json: { 
      status: 200,
      logged_out: true,
    }
  end

end
