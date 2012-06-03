module SuddenKiller
  class TwitterInterface

    def initialize(killer)
      @killer = killer
      @keep_silent_until = Time.now
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

    def follow(user_id)
    end

    def post(text)
    end
  end
end
