class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @wishlists = Wishlist.where(user_id: @user.id).to_a || []
    wishlist_ids = @wishlists.pluck(:venue_id)

    url = "https://api.foursquare.com/v2/checkins/recent?"
    url += "limit=5&"
    url += "oauth_token=#{session[:access_token]}&"
    url += "v=20180101"

    response = JSON.parse(HTTParty.get(url, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).body)

    @recents = []

    response["response"]["recent"].each do |recent|
      id = recent['venue']['id']
      unless wishlist_ids.include? id
        recent_item = Hash.new
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

        @recents << recent_item
      end
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
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
