require 'rails_helper'

RSpec.describe "Attempts", type: :request do
  describe "POST /games/:id/attempts" do
    let(:headers) { { 'Content-Type' => 'application/json', 'Accept' => 'application/json' } }

    context 'with an invalid game' do
      it 'returns a 404' do
        expect do
          post '/games/invalid/attempts', headers: headers
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with a valid game' do
      let(:game) { Game.create }

      context 'with invalid params' do
        let(:params) { { guess: "foo" * game.word_length } }

        it 'returns a 422' do
          post "/games/#{game.uuid}/attempts", params: { attempt: params }.to_json, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not register the attempt' do
          expect do
            post "/games/#{game.uuid}/attempts", params: { attempt: params }.to_json, headers: headers
          end.not_to change(Attempt, :count)
        end
      end

      context 'with valid params' do
        let(:params) { { guess: "sword" } }

        it 'returns a 201' do
          post "/games/#{game.uuid}/attempts", params: { attempt: params }.to_json, headers: headers
          expect(response).to have_http_status(:created)
        end

        it 'registers the attempt on the currently active word' do
          expect do
            post "/games/#{game.uuid}/attempts", params: { attempt: params }.to_json, headers: headers
          end.to change(game.words.find_by(status: "ongoing").attempts, :count).by(1)
        end
      end
    end

    context 'with a finished game' do
      let(:game) { Game.create(status: "done") }
      let(:params) { { guess: "sword" } }

      it 'returns a 404' do
        expect do
          post "/games/#{game.uuid}/attempts", params: { attempt: params }.to_json, headers: headers
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
