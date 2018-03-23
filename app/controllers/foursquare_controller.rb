class FoursquareController < ApplicationController
  def callback
    session[:access_token] = FoursquareService::API.new.get_auth_token(params[:code])
    user_response = FoursquareService::API.new.get_user(session[:access_token])

    username = user_response['response']['user']['firstName']
    foursquare_id = user_response['response']['user']['id']
    photo = user_response['response']['user']['photo']['prefix'] + '100x100' + user_response['response']['user']['photo']['suffix']

    user = User.find_or_create_by(username: username, foursquare_id: foursquare_id, photo: photo)
    session[:user_id] = user.id
    redirect_to user_url(user)

  rescue JSON::ParserError => e
    Rails.logger.error(e.message)
    return false
  end
end
