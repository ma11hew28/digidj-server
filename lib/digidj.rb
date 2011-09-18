require "json"    # JSON decode/encode
require "logger"  # log errors
require "redis"   # store data

module DigiDJ
  class << self
    def redis
      Redis.new()
    end

    def host
      @@host ||= "http://127.0.0.1:4567"
    end

    def root
      @@root ||= File.expand_path(File.join("..", ".."), __FILE__)
    end

    def env
      @@env = ENV["RACK_ENV"] || "development"
    end

    def logger
      @@logger ||= nil
    end

    def logger=(logger)
      @@logger = logger
    end
  end
end

require "digidj/core/object/blank"
require "digidj/playlist"
require "digidj/track"
require "digidj/application"
