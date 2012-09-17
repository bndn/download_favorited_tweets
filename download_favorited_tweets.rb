#!/usr/bin/env ruby

gem 'twitter', '3.7.0'
gem 'json', '1.7.5'

require 'twitter'
require 'json'

# configuration
filename = 'favorites.json'
Twitter.configure do |config|
  config.consumer_key = 'YOUR_CONSUMER_KEY'
  config.consumer_secret = 'YOUR_CONSUMER_SECRET'
  config.oauth_token = 'YOUR_ACCESS_TOKEN'
  config.oauth_token_secret = 'YOUR_ACCESS_TOKEN_SECRET'
end

# initialize variables
tweets = []
options = { :count => 200 }

# call Twitter API to download tweets
calls_count = (Twitter.user.favorites_count / options[:count].to_f).ceil
calls_count.times do
  tweets += Twitter.favorites(options)
  options[:max_id] = tweets.last.id - 1
end

# select essential attributes and reverse the order of tweets
tweets.reverse!.map! do |t|
  {
    :created_at => t.created_at,
    :id => t.id,
    :text => t.text,
    :user => {
      :id => t.user.id,
      :name => t.user.name,
      :screen_name => t.user.screen_name
    }
  }
end

# save tweets in the JSON file
File.open(filename, 'w') do |file|
  file.write(tweets.to_json)
end

# open your JSON file!

