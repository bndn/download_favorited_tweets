# Download Favorited Tweets

A Ruby script to download and save all your favorited tweets in a JSON file.

## Usage

    $ git clone git://github.com/sphax3d/download_favorited_tweets.git
    $ cd download_favorited_tweets
    ### Set the JSON file, valid API consumer key, consumer secret and OAuth tokens in the Ruby script
    $ ruby download_favorited_tweets.rb

Run the script once a week (every Monday at 19:50) :

    $ crontab -e
    > 50 19 * * 1 ruby /path/to/your/download_favorited_tweets.rb

## To-do list

- Organize the script like these following scripts: https://github.com/discordianfish/download_tweets and https://github.com/klebershimabuku/twitter-favorites
- Save tweets in multiple tweet files
- Allow to choose tweet attributes to save
- Download and save only new favorited tweets

