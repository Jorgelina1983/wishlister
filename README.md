# README

This is a basic project in rails that interacts with Foursquare API. Get users, venues and recent checkins form friends and creates a wishlist of venues.

It will fetch 15 venues from recent checkins from friends. Magic number, no reason, I just choose 15.

Requirements for this application to run locally:

- Install Ruby 2.3.1
- Get the repo with the code.
- `gem install bundler`
- `bundle install`
- `rake db:migrate`

After this there are 3 enviorment variables that need to be set:

export CLIENT_ID=<ask_me_for_the_value>
export CLIENT_SECRET=<ask_me_for_the_value>
export REDIRECT_URL=http://localhost:3000/foursquare/callback

And start the Rails server with `rails s`.
The root url for the app to run locally will be http://localhost:3000.

If this looks too complicated, https://jaya-wishlister.herokuapp.com this is a live demo of the app.
