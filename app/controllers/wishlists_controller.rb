class WishlistsController < ApplicationController
  before_action :set_wishlist, only: [:show, :edit, :update, :destroy]

  # GET /wishlists
  # GET /wishlists.json
  def index
    set_user
    @wishlists = Wishlist.where(user_id: @user.id) || []
  end

  # POST /wishlists
  # POST /wishlists.json
  def create
    wishlist = Wishlist.new(wishlist_params)
    wishlist.venue_name = wishlist.venue_name.strip
    wishlist.user_id = current_user.id

    respond_to do |format|
      if wishlist.save
        response = render_to_string('wishlists/_wishlist_card', :layout => false, :locals => { :wishlist => wishlist })
        format.json { render json:{ html_data: response } }
      else
        # format.html { render :new }
        format.json { render json: wishlist.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
    wishlist = Wishlist.where(venue_id: params[:venue_id]).first
    wishlist.destroy

    respond_to do |format|
      if wishlist.destroyed?
          venue = getVenue(wishlist.venue_id)
          response = render_to_string('users/_recent_card', :layout => false, :locals => { :recent => venue })
          format.json { render json:{ html_data: response } }
        else
          format.json { render json: wishlist.errors, status: :unprocessable_entity }
      end
    end
  end

  def getVenue(venue_id)
    response = FoursquareService::API.new.get_recent_checkins(session[:access_token])
    recent_item = Hash.new

    response["response"]["recent"].each do |recent|
      id = recent['venue']['id']
      if id == venue_id
        recent_item[:venue_id] = id
        recent_item[:venue_name] = recent['venue']['name']
        recent_item[:user_name] = "#{recent['user']['firstName']} #{recent['user']['lastName']}"
        recent_item[:user_photo] = "#{recent['user']['photo']['prefix'] + '100x100' + recent['user']['photo']['suffix']}"

        # get venue photo
        venue_id = recent['venue']['id']

        venue_response = FoursquareService::API.new.get_venue(venue_id, session[:access_token])
        prefix = venue_response['response']['venue']['photos']['groups'][0]['items'][0]['prefix']
        suffix = venue_response['response']['venue']['photos']['groups'][0]['items'][0]['suffix']

        recent_item[:venue_photo] = "#{prefix}300x300#{suffix}"
      end
    end

    recent_item
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wishlist
      # @wishlist = Wishlist.find(params[:id])
    end

    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wishlist_params
      params.permit(:venue_name, :venue_photo, :venue_id)
    end
end
