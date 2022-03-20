require 'uri'
require 'net/http'

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

  def cardscan_session
    # Generates a cardscan.ai token for the logged-in user and returns it.
    uri = URI("https://sandbox.cardscan.ai/v1/access-token")
    params = {
      :user_id => current_user.id
    }

    req = Net::HTTP::Get.new(uri)
    req.form_data = params
    req['Authorization'] = "Bearer #{ENV["CARDSCAN_AI_KEY"]}"
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https' ) { |http|
      http.request(req) 
    }

    if res.msg == "OK"
      render json: {
        res: res,
        token: JSON.parse(res.body)
      }
    else
      render json: {
        res: res,
        error: res.msg
      }
    end
    
  end

end
