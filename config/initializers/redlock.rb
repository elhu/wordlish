REDLOCK = Redlock::Client.new([ENV.fetch('REDIS_URL', "redis://localhost")])
