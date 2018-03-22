class WishlistsController < ApplicationController
  before_action :set_wishlist, only: [:show, :edit, :update, :destroy]

  # GET /wishlists
  # GET /wishlists.json
  def index
    set_user
    @wishlists = Wishlist.where(user_id: @user.id) || []
  end

  # GET /wishlists/1
  # GET /wishlists/1.json
  def show
  end

  # GET /wishlists/new
  def new
    @wishlist = Wishlist.new
  end

  # GET /wishlists/1/edit
  def edit
  end

  # POST /wishlists
  # POST /wishlists.json
  def create
    wishlist = Wishlist.new(wishlist_params)
    wishlist.venue_name = wishlist.venue_name.strip
    wishlist.user_id = current_user.id

    respond_to do |format|
      if wishlist.save
        # format.html { redirect_to @wishlist, notice: 'Wishlist was successfully created.' }
        # format.json { render :_wishlist_card, wishlist: wishlist }
        response = render_to_string('wishlists/_wishlist_card', :layout => false, :locals => { :wishlist => wishlist })
        format.json { render json:{ html_data: response } }
      else
        # format.html { render :new }
        format.json { render json: wishlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wishlists/1
  # PATCH/PUT /wishlists/1.json
  def update
    respond_to do |format|
      if @wishlist.update(wishlist_params)
        format.html { redirect_to @wishlist, notice: 'Wishlist was successfully updated.' }
        format.json { render :show, status: :ok, location: @wishlist }
      else
        format.html { render :edit }
        format.json { render json: @wishlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wishlists/1
  # DELETE /wishlists/1.json
  def destroy
    @wishlist.destroy
    respond_to do |format|
      format.html { redirect_to wishlists_url, notice: 'Wishlist was successfully destroyed.' }
      format.json { head :no_content }
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
    url = "https://api.foursquare.com/v2/checkins/recent?"
    url += "limit=5&"
    url += "oauth_token=#{session[:access_token]}&"
    url += "v=20180101"

    response = JSON.parse(HTTParty.get(url, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).body)

    recent_item = Hash.new
    response["response"]["recent"].each do |recent|
      id = recent['venue']['id']
      if id == venue_id
        recent_item[:venue_id] = id
        recent_item[:venue_name] = recent['venue']['name']
        recent_item[:user_name] = "#{recent['user']['firstName']} #{recent['user']['lastName']}"
        recent_item[:user_photo] = "#{recent['user']['photo']['prefix'] + '100x100' + recent['user']['photo']['suffix']}"

        # venue photo
        venue_id = recent['venue']['id']
        venue_url = "https://api.foursquare.com/v2/venues/#{venue_id}?"
        venue_url += "limit=20&"
        venue_url += "oauth_token=#{session[:access_token]}&"
        venue_url += "v=20180101"

        venue_response = JSON.parse(HTTParty.get(venue_url, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).body)

        prefix = venue_response['response']['venue']['photos']['groups'][0]['items'][0]['prefix']
        suffix = venue_response['response']['venue']['photos']['groups'][0]['items'][0]['suffix']

        recent_item[:venue_photo] = "#{prefix}300x300#{suffix}"

        # @recents << recent_item
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
