# -*- coding: utf-8 -*-
module SuddenKiller
  class TwitterInterface

    def initialize(killer,interval)
      @killer = killer
      @interval = interval
      @keep_silent_until = Time.now
    end

    def run
      loop do
        begin
          stream_client.user do |status|
            recieve_status(status)
          end
        rescue => e
          p e
        end
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

    def recieve_reply(status)
      if status[:text].include?('unfollow')
        unfollow(status[:user][:id])
      end
    end

    def recieve_tweet(status)
      if (status[:text].include?('@totsuzenshi_bot'))
        recieve_reply(status)
      end

      return nil if status[:text].include?('@')
      return nil if status[:user][:protected]

      now = Time.now
      if (now < @keep_silent_until)
        return nil
      end

      text = @killer.kill(status[:text])
      return nil unless text

      return nil if text.size > 140
      return nil if text.size < 40

      @keep_silent_until = now + (60 * @interval)
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

    def unfollow(user_id)
      twitter_client.unfollow(user_id)
    end

    def post(text)
      twitter_client.update(text)
    end
  end
end
