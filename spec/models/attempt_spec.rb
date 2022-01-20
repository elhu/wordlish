require 'rails_helper'

RSpec.describe Attempt, type: :model do
  let(:word) { Game.create.words.first }

  describe 'guess' do
    it { is_expected.to validate_presence_of(:guess) }
    it { is_expected.to have_readonly_attribute(:guess) }

    context 'with a word the wrong length' do
      subject { word.attempts.build(guess: 'word') }

      it { is_expected.not_to be_valid }
    end

    context 'with a word the correct length' do
      subject { word.attempts.build(guess: 'sword', position: 0) }

      it { is_expected.to be_valid }
    end
  end

  describe 'position' do
    it { is_expected.to validate_presence_of(:position) }
    it { is_expected.to validate_numericality_of(:position) }
  end

  describe 'word' do
    it { is_expected.to belong_to(:word) }
  end
end
