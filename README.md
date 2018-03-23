# README

This is a basic project in rails that interacts with Foursquare API. Get users, venues and recent checkins form friends and creates a wishlist of venues.

It will fetch 15 venues from recent checkins from friends. Magic number, no reason, I just choose 15.

Requirements for this application to run locally:

- Install Ruby 2.3.1
- Get the repo with the code.
- `gem install bundler`
- `bundle install`
- `rake db:migrate`

And start the Rails server with `rails s`.
The root url for the app to run locally will be http://localhost:3000.

If this looks too complicated, https://jaya-wishlister.herokuapp.com this is a live demo of the app.
