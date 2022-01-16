require 'rails_helper'

RSpec.describe Word, type: :model do
  subject { game.words.build }

  let(:game) { Game.create }

  describe 'game' do
    it { is_expected.to belong_to(:game) }
  end

  describe 'score' do
    it { is_expected.to validate_presence_of(:score) }
    it { is_expected.to validate_numericality_of(:score) }
  end

  describe 'status' do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to define_enum_for(:status).with_values({ not_started: "not_started", ongoing: "ongoing", done: "done" }).backed_by_column_of_type(:enum).with_prefix(:status) }

    describe 'default value' do
      subject { described_class.create.status }

      it { is_expected.to eq("not_started") }
    end
  end

  describe 'to_guess' do
    it { is_expected.to validate_presence_of(:to_guess) }
    it { is_expected.to have_readonly_attribute(:to_guess) }

    context 'with a word the wrong length' do
      subject { game.words.build(to_guess: 'word') }

      it { is_expected.not_to be_valid }
    end

    context 'with a word the correct length' do
      subject { game.words.build(to_guess: 'sword') }

      it { is_expected.to be_valid }
    end
  end
end
