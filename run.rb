require 'rubygems'
require 'bundler'
require 'yaml'

Bundler.require(:default, :development)
Dotenv.load if defined?(Dotenv)

require './feed_reader'
require './microblog_updater'
require './status'
require './twitter_client'

TWITTER_CLIENT = TwitterClient.new \
  consumer_key: ENV['TWITTER_CONSUMER_KEY'],
  consumer_secret: ENV['TWITTER_CONSUMER_SECRET'],
  access_token: ENV['TWITTER_ACCESS_TOKEN'],
  access_token_secret: ENV['TWITTER_ACCESS_TOKEN_SECRET']

MicroblogUpdater.call(TWITTER_CLIENT, ENV['MICROBLOG_FEED_URL'])
