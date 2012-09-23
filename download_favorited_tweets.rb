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

# load tweets previously saved
tweets = JSON.load(File.new(filename)) || []
last_saved_tweet_id = tweets.last['id'] unless tweets.empty?
last_saved_tweet_reached = false

# call Twitter API to download recent tweets
recent_tweets = []
options = { :count => 10 }
call_counter = 0
until last_saved_tweet_reached do
  downloaded_tweets = Twitter.favorites(options)
  call_counter += 1
  # increase the number of downloaded tweets by API call
  # if there is a lot of recent favorited tweets
  options[:count] = case call_counter
    when 3 then 50
    when 5 then 200
  end

  # first favorited tweet reached?
  if downloaded_tweets.empty?
    last_saved_tweet_reached = true
  else
    options[:max_id] = downloaded_tweets.last[:id] - 1

    # select essential attributes
    downloaded_tweets.map! do |t|
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

    # search the last saved tweet
    last_saved_tweet_index = downloaded_tweets.index do |t|
      t[:id] == last_saved_tweet_id
    end
    if last_saved_tweet_index
      last_saved_tweet_reached = true
      # take only recent tweets
      downloaded_tweets.slice!(last_saved_tweet_index, downloaded_tweets.length)
    end

    recent_tweets += downloaded_tweets
  end
end

unless recent_tweets.empty?
  # merge all tweets sorted by tweet id order
  tweets |= recent_tweets.reverse

  # save tweets in the JSON file
  File.open(filename, 'w') do |file|
    file.write(tweets.to_json)
  end
end

# open your JSON file!

