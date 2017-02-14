class TwitterClient
  BASE_URL = 'https://api.twitter.com/1.1'.freeze

  def initialize(consumer_key:, consumer_secret:, access_token:, access_token_secret:)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = consumer_key
      config.consumer_secret = consumer_secret
      config.access_token = access_token
      config.access_token_secret = access_token_secret
    end
  end

  def configuration
    request(:get, '/help/configuration.json')
  end

  def short_url_length
    @short_url_length ||= configuration[:short_url_length]
  end

  def update(*args)
    client.update(*args)
  end

  def destroy_status(*args)
    client.destroy_status(*args)
  end

  def user_timeline(*args)
    client.user_timeline(*args)
  end

  private

  attr_reader :client

  def request(method, path)
    Twitter::REST::Request.new(client, method, "#{BASE_URL}#{path}").perform
  end
end
