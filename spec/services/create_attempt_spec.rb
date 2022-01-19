require 'rails_helper'

RSpec.describe CreateAttempt do
  subject(:service) { described_class.new(game: game, guess: guess) }

  let(:game) { Game.create }

  describe '#call' do
    let(:response) { service.call }

    context 'with a valid guess' do
      let(:guess) { 'words' }

      it 'returns a success state' do
        expect(response.success?).to be(true)
      end

      it 'returns the attempt' do
        attempt = response.payload[:attempt]
        expect(attempt).to be_kind_of(Attempt)
        expect(attempt.word.game).to eq(game)
      end

      context 'when word is the actual answer' do
        let(:word) { game.words.find_by(status: 'ongoing') }
        let(:guess) { word.to_guess }

        it 'flags the word as done' do
          expect do
            service.call
          end.to change { word.reload.status }.to('done')
        end
      end

      context 'when word is not the actual answer' do
        let(:word) { game.words.find_by(status: 'ongoing') }

        context 'when the word still has attempts left' do
          it 'does not flag the word as done' do
            expect do
              service.call
            end.not_to(change { word.reload.status })
          end
        end

        context 'when word is out of attempts' do
          before do
            (game.max_attempts - 1).times do
              described_class.new(game: game, guess: guess).call
            end
          end

          it 'flags the word as done' do
            expect do
              service.call
            end.to change { word.reload.status }.to('done')
          end

          context 'when game has more words pending' do
            it 'sets the next word as ongoing' do
              previous_word = word
              service.call
              expect(game.words.where(status: 'ongoing').count).to eq(1)
              expect(game.words.where(status: 'ongoing').first).not_to eq(previous_word)
            end
          end

          context 'when game is out of words' do
            before do
              game.words.where.not(id: word.id).update(status: 'done')
            end

            it 'flags the game as done' do
              expect do
                service.call
              end.to change(game, :status).to('done')
            end

            it 'computes the score for the game' do
              expect do
                service.call
              end.to change(game, :score)
            end
          end
        end
      end
    end

    context 'with an invalid guess' do
      let(:guess) { 'foo' }

      it 'returns a failed state' do
        expect(response.success?).to be(false)
      end

      it 'returns a detailed error message' do
        expect(response.errors).to be_present
      end
    end
  end
end
