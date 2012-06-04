module SuddenKiller
  class TwitterInterface
    module Configuration
      OPTIONS_KEYS = [:consumer_key,
                      :consumer_secret,
                      :oauth_token,
                      :oauth_token_secret].freeze

      class << self
        attr_accessor *OPTIONS_KEYS
        def configure
          yield self
          self
        end
      end
    end
  end
end
