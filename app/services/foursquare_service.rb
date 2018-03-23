module FoursquareService
  class API
    def get_auth_token(auth_code)
      url = "https://foursquare.com/oauth2/access_token?"
      url += "client_id=#{ENV['CLIENT_ID']}&"
      url += "client_secret=#{ENV['CLIENT_SECRET']}&"
      url += "grant_type=authorization_code&"
      url += "redirect_uri=#{ENV['REDIRECT_URL']}&"
      url += "code=#{auth_code}&"

      response = get_api_response(url)
      response['access_token']
    end

    def get_auth_url
      client_id = ENV['CLIENT_ID']
      redirect_uri = ENV['REDIRECT_URL']

      "https://foursquare.com/oauth2/authorize?client_id=#{client_id}&response_type=code&redirect_uri=#{redirect_uri}"
    end

    def get_user(auth_token)
      url = "https://api.foursquare.com/v2/users/self?"
      url += "oauth_token=#{auth_token}&"
      url += "v=20180101"

      get_api_response(url)
    end

    def get_recent_checkins(auth_token)
      url = "https://api.foursquare.com/v2/checkins/recent?"
      url += "limit=15&"
      url += "oauth_token=#{auth_token}&"
      url += "v=20180101"

      get_api_response(url)
    end

    def get_venue(id, auth_token)
      url = "https://api.foursquare.com/v2/venues/#{id}?"
      url += "limit=20&"
      url += "oauth_token=#{auth_token}&"
      url += "v=20180101"

      get_api_response(url)
    end

    def get_api_response(url)
      JSON.parse(HTTParty.get(url, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).body)
    end
  end
end