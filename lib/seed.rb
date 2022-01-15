class Seed
  MAX_INT = 2**64 - 1

  def self.generate(seed = Random.new_seed)
    [seed.divmod(MAX_INT).reverse.pack("Q*")].pack("m").strip
  end

  def self.unpack(seed)
    parts = seed.unpack1("m").unpack("Q*")
    parts[1] * MAX_INT + parts[0]
  end
end
