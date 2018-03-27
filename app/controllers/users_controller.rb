class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users/1
  # GET /users/1.json
  def show
    @wishlists = Wishlist.where(user_id: @user.id).to_a || []
    wishlist_ids = @wishlists.pluck(:venue_id)

    response = FoursquareService::API.new.get_recent_checkins(session[:access_token])
    @recents = []

    response["response"]["recent"].each do |recent|
      id = recent['venue']['id']
      unless wishlist_ids.include? id
        recent_item = Hash.new
        recent_item[:venue_id] = id
        recent_item[:venue_name] = recent['venue']['name']
        recent_item[:user_name] = "#{recent['user']['firstName']} #{recent['user']['lastName']}"
        recent_item[:user_photo] = "#{recent['user']['photo']['prefix'] + '100x100' + recent['user']['photo']['suffix']}"

        # get venue photo
        venue_id = recent['venue']['id']

        venue_response = FoursquareService::API.new.get_venue(venue_id, session[:access_token])
        if venue_response['response']['venue']['photos']['count'] != 0
          prefix = venue_response['response']['venue']['photos']['groups'][0]['items'][0]['prefix']
          suffix = venue_response['response']['venue']['photos']['groups'][0]['items'][0]['suffix']

          recent_item[:venue_photo] = "#{prefix}300x300#{suffix}"
        else
          recent_item[:venue_photo] = "https://www.socabelec.co.ke/wp-content/uploads/no-photo-14.jpg"
        end

        @recents << recent_item
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.fetch(:user, {})
    end
end
