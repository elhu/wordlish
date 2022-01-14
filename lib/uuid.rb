class UUID
  SYMBOLS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~".freeze

  def self.generate
    uuid_int = SecureRandom.uuid.gsub('-', '').to_i(16)
    digits = []
    while uuid_int > 0
      digits << SYMBOLS[uuid_int % SYMBOLS.length]
      uuid_int /= SYMBOLS.length
    end
    digits.join
  end
end
