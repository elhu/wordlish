require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'max_attempts' do
    it { is_expected.to validate_presence_of(:max_attempts) }
    it { is_expected.to validate_numericality_of(:max_attempts).is_less_than_or_equal_to(10).is_greater_than_or_equal_to(4) }

    describe 'default value' do
      subject { described_class.create.max_attempts }

      it { is_expected.to eq(6) }
    end
  end

  describe 'max_words' do
    it { is_expected.to validate_presence_of(:max_words) }
    it { is_expected.to validate_numericality_of(:max_words).is_less_than_or_equal_to(50).is_greater_than_or_equal_to(10) }

    describe 'default value' do
      subject { described_class.create.max_words }

      it { is_expected.to eq(25) }
    end
  end

  describe 'seed' do
    it { is_expected.to have_readonly_attribute(:seed) }

    describe 'when saving a new record' do
      let(:game) { described_class.new }

      it 'generates a seed' do
        expect { game.save! }.to change(game, :seed)
      end
    end

    describe 'when saving an existing record' do
      let(:game) { described_class.create! }

      it 'does not change the seed' do
        expect { game.save }.not_to change(game, :seed)
      end
    end
  end

  describe 'score' do
    it { is_expected.to validate_presence_of(:score) }
    it { is_expected.to validate_numericality_of(:score) }
  end

  describe 'status' do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to define_enum_for(:status).with_values({ ongoing: "ongoing", done: "done" }).backed_by_column_of_type(:enum).with_prefix(:status) }

    describe 'default value' do
      subject { described_class.create.status }

      it { is_expected.to eq("ongoing") }
    end
  end

  describe 'uuid' do
    subject { described_class.create }

    it { is_expected.to have_readonly_attribute(:uuid) }
    it { is_expected.to validate_uniqueness_of(:uuid) }

    describe 'when saving a new record' do
      let(:game) { described_class.new }

      it 'generates a uuid' do
        expect { game.save! }.to change(game, :uuid)
      end
    end

    describe 'when saving an existing record' do
      let(:game) { described_class.create! }

      it 'does not change the uuid' do
        expect { game.save }.not_to change(game, :uuid)
      end
    end
  end

  describe 'word_length' do
    it { is_expected.to validate_presence_of(:word_length) }
    it { is_expected.to validate_numericality_of(:word_length).is_less_than_or_equal_to(16).is_greater_than_or_equal_to(3) }

    describe 'default value' do
      subject { described_class.create.word_length }

      it { is_expected.to eq(5) }
    end
  end

  describe 'words' do
    it { is_expected.to have_many(:words).dependent(:destroy) }

    context 'when updating an existing record' do
      let!(:game) { described_class.create! }

      it 'does not add new words' do
        expect do
          game.save
        end.not_to change(Word, :count)
      end
    end

    context 'when creating a new record' do
      let(:game) { described_class.new(max_words: 10) }

      it 'saves the right number of words' do
        expect do
          game.save
        end.to change(Word, :count).by(game.max_words)
      end

      it 'saves the words of the right length' do
        game.save
        expect(game.words.map(&:to_guess).map(&:length)).to all(eq(game.word_length))
      end

      it 'sets the first word as ongoing' do
        game.save
        expect(game.words.first.status).to eq("ongoing")
      end

      it 'sets the other words as not_started' do
        game.save
        expect(game.words[1..].map(&:status)).to all(eq('not_started'))
      end
    end
  end
end
