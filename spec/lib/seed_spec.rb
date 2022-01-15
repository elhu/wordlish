require 'rails_helper'
require 'seed'

RSpec.describe Seed do
  it 'generates a reversible seed' do
    seed = Random.new_seed
    expect(described_class.unpack(described_class.generate(seed))).to eq(seed)
  end
end
