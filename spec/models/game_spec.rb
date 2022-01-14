require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:uuid) }

    it { is_expected.to validate_uniqueness_of(:uuid) }

    it { is_expected.to validate_presence_of(:status) }

    it do
      expect(subject).to define_enum_for(:status)
        .with_values({ ongoing: "ongoing", done: "done" })
        .backed_by_column_of_type(:enum)
        .with_prefix(:status)
    end
  end

  describe 'uuid' do
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
end
