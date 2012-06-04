module SuddenKiller
  class TwitterInterface

    def initialize(killer)
      @killer = killer
      @keep_silent_until = Time.now
    end

    def run
      stream_client.user do |status|
        p status
        recieve_status(status)
      end
    end

    private

    def recieve_status(status)
      if status[:event] && status[:event] == 'follow'
        recieve_follow_event(status)
      end
      if status[:text]
        recieve_tweet(status)
      end
    end

    def recieve_follow_event(status)
      user_id = status[:source][:id]
      follow(user_id)
    end

    def recieve_tweet(status)
      return nil if status[:text].include?('@')

      text = @killer.kill(status[:text])
      return nil unless text

      return nil if text.size > 140

      now = Time.now
      if (now < @keep_silent_until)
        return nil
      end

      @keep_silent_until = now + (60 * 10) # 10 min.
      post(text)
    end

    def twitter_client
      @twitter_client ||= lambda do
        Twitter.configure do |config|
          config.consumer_key       = Configuration.consumer_key
          config.consumer_secret    = Configuration.consumer_secret
          config.oauth_token        = Configuration.oauth_token
          config.oauth_token_secret = Configuration.oauth_token_secret
        end
        Twitter::Client.new
      end.call
    end

    def stream_client
      @stream_client ||= lambda do
        UserStream.configure do |config|
          config.consumer_key       = Configuration.consumer_key
          config.consumer_secret    = Configuration.consumer_secret
          config.oauth_token        = Configuration.oauth_token
          config.oauth_token_secret = Configuration.oauth_token_secret
        end
      end.call
    end

    def follow(user_id)
      twitter_client.follow(user_id)
    end

    def post(text)
      twitter_client.update(text)
    end
  end
end
