require 'seed'

class WordPicker
  SEED_SALT = Seed.unpack(Rails.application.credentials.random_seed)
  WORDS = Zlib::GzipReader.open(
    Rails.root.join("public/words.txt.gz")
  ).readlines.map(&:strip).group_by(&:length).freeze

  WORDS_SET = Set.new(Zlib::GzipReader.open(
    Rails.root.join("public/words.txt.gz")
  ).readlines.map(&:strip)).freeze

  attr_accessor :config

  def self.exists?(word)
    WORDS_SET.include?(word)
  end

  def initialize(config)
    self.config = config
  end

  def pick_words
    WORDS[config.word_length].sample(config.max_words, random: Random.new(Seed.unpack(config.seed) + SEED_SALT))
  end
end
