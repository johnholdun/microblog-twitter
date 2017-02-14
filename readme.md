# Microblog-Twitter Syndicator

Syndicate a microblog RSS feed to Twitter. Every time this application runs, it deletes any tweets older than 24 hours and posts any new tweets from your feed. HTML is stripped and links (and images, and embeds) are shared as URLs at the end of the tweet.

A tweet that will fit in 140 characters after formatting is sent as-is; a tweet that won't fit is truncated and includes the permalink from you feed.

## Setup and Deployment

Configure your installation by setting these environment variables:

- `TWITTER_CONSUMER_KEY`
- `TWITTER_CONSUMER_SECRET`
- `TWITTER_ACCESS_TOKEN`
- `TWITTER_ACCESS_TOKEN_SECRET`
- `MICROBLOG_FEED_URL`

(Locally I use [Dotenv](https://github.com/bkeepers/dotenv); in production I use Heroku config.)

Update your Twitter feed by just running `rake`:

```
bundle install
bundle exec rake
```

I personally run this for [@johnholdun2](https://twitter.com/johnholdun2) every ten minutes with the Heroku scheduler. Close enough!
