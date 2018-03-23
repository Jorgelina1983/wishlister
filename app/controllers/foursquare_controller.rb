class FoursquareController < ApplicationController
  def callback
    auth_code = params[:code]

    url = "https://foursquare.com/oauth2/access_token?"
    url += "client_id=#{ENV['CLIENT_ID']}&"
    url += "client_secret=#{ENV['CLIENT_SECRET']}&"
    url += "grant_type=authorization_code&"
    url += "redirect_uri=#{ENV['REDIRECT_URL']}&"
    url += "code=#{auth_code}&"

    response = JSON.parse(HTTParty.get(url, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).body)

    session[:access_token] = response["access_token"]

    @response = response
    user_url = "https://api.foursquare.com/v2/users/self?"
    user_url += "oauth_token=#{response["access_token"]}&"
    user_url += "v=20180101"

    user_response = JSON.parse(HTTParty.get(user_url, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).body)

    username = user_response['response']['user']['firstName']
    foursquare_id = user_response['response']['user']['id']
    photo = user_response['response']['user']['photo']['prefix'] + '100x100' + user_response['response']['user']['photo']['suffix']

    user = User.find_or_create_by(username: username, foursquare_id: foursquare_id, photo: photo)
    session[:user_id] = user.id
    redirect_to user_url(user)

    # User.find_or_create_by(:username )
    rescue JSON::ParserError => e
      Rails.logger.error(e.message)
      return false
    end
  end
