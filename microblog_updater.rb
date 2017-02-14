class MicroblogUpdater
  def initialize(twitter_client, microblog_feed_url)
    @twitter_client = twitter_client
    @microblog_feed_url = microblog_feed_url
  end

  def call
    puts 'Hello!'
    delete_expired_tweets
    create_new_tweets
    puts 'All done!'
  end

  def self.call(*args)
    new(*args).call
  end

  private

  attr_reader :twitter_client, :microblog_feed_url

  def delete_expired_tweets
    puts "#{expired_tweets.count} expired tweet#{'s' unless expired_tweets.count == 1}"
    return unless expired_tweets.size > 0
    puts "Deleting #{expired_tweets.map(&:id).join(', ')}..."
    twitter_client.destroy_status(expired_tweets)
  end

  def create_new_tweets
    puts "#{new_tweets.count} new tweet#{'s' unless new_tweets.count == 1}"
    new_tweets.each do |status|
      print "Creating '#{status.summary}'..."
      response = twitter_client.update(status.summary)
      puts response.try(:id)
    end
  end

  def existing_tweets
    @existing_tweets ||= TWITTER_CLIENT.user_timeline
  end

  def expired_tweets
    @expired_tweets ||= existing_tweets.select { |t| expired?(t.created_at) }
  end

  def new_tweets
    feed_posts.reject do |post|
      expired?(post.published_at) ||
      existing_tweets.any? { |t| t.text.start_with?(post.summary) }
    end
  end

  def feed_posts
    @feed_posts ||= FeedReader.call \
      microblog_feed_url,
      short_url_length: twitter_client.short_url_length
  end

  def expired?(time)
    (Time.now - time) / (60 * 60 * 24).to_f > 1
  end
end
