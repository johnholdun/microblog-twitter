class FeedReader
  def initialize(url, short_url_length: 23)
    @url = url
    @short_url_length = short_url_length
  end

  def call
    posts
  end

  def self.call(*args)
    new(*args).call
  end

  private

  attr_reader :url, :short_url_length

  def posts
    feed.entries.map do |entry|
      Status.new(entry, short_url_length: short_url_length)
    end
  end

  def feed
    @feed ||= Feedjira::Feed.fetch_and_parse(url)
  end
end
