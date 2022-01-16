require 'rails_helper'
require 'word_picker'

RSpec.describe WordPicker do
  it 'generates the same words for a given config' do
    config = OpenStruct.new(seed: Seed.generate, max_words: 5, word_length: 5)
    words = described_class.new(config).pick_words
    expect(described_class.new(config).pick_words).to eq(words)
  end

  it 'generates different words for a different seed' do
    config = OpenStruct.new(seed: Seed.generate, max_words: 5, word_length: 5)
    words = described_class.new(config).pick_words
    config.seed = Seed.generate
    expect(described_class.new(config).pick_words).not_to eq(words)
  end
end
