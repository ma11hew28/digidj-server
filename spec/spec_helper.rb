require "digidj"

module DigiDJ
  class Application
    set :environment, :test
  end
end

RSpec.configure do |c|
  c.before(:each) { DigiDJ.redis.flushdb }
end
