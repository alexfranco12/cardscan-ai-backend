require 'uri'
require 'json'
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

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{ENV["CARDSCAN_AI_KEY"]}"
    request.form_data = params

    response = https.request(request)

    if response.msg == "OK"
      render json: {
        response: response,
        status: response.code,
        message: response.message,
        session: JSON.parse(response.body)
      }
    else
      render json: {
        response: response,
        status: response.code,
        error: response.message,
      }
    end
    
  end

  def scan_document
    uri = URI("https://sandbox.cardscan.ai/v1/generate-upload-url")
    params = {
      # :image => post_params,
      :live => false
    }

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{ENV["CARDSCAN_AI_KEY"]}"
    request.form_data = params

    response = https.request(request)

    if response.msg == "OK"
      render json: {
        response: response,
        status: response.code,
        message: response.message,
        details: JSON.parse(response.body)
      }
    else
      render json: {
        response: response,
        status: response.code,
        error: response.message,
      }
    end
  end

  def card
    url = URI("https://sandbox.cardscan.ai/v1/cards/#{params[:card_id]}")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{ENV["CARDSCAN_AI_KEY"]}"

    response = https.request(request)

    if response.msg == "OK"
      render json: {
        response: response,
        status: response.code,
        message: response.message,
        card: JSON.parse(response.body)
      }
    else
      render json: {
        response: response,
        status: response.code,
        error: response.message,
      }
    end

  end

  private
  def post_params
    params.permit(:image)
  end

end
