module SuddenKiller
  class TwitterInterface
    def initialize(killer)
      @killer = killer
    end

    def recieve_status(status)
      if status[:event] && status[:event] == 'follow'
        recieve_follow_event(status)
      end
      if status[:text]
        recieve_tweet(status)
      end
    end

    private
    attr_accessor :killer

    def recieve_follow_event(status)
      user_id = status[:source][:id]
      follow(user_id)
    end

    def recieve_tweet(status)
      text = killer.kill(status[:text])
      return unless text
      post(text)
    end

    def follow(user_id)
    end

    def post(text)
    end
  end
end
