require 'rails_helper'

RSpec.describe 'games', type: :request do
  describe 'POST /games' do
    let(:headers) { { 'Content-Type' => 'application/json', 'Accept' => 'application/json' } }

    context 'without params' do
      it 'returns a 201 status code' do
        post '/games', headers: headers
        expect(response).to have_http_status(:created)
      end

      it 'creates a new game' do
        expect do
          post '/games', headers: headers
        end.to change(Game, :count).by(1)
      end

      it 'uses the default configuration' do
        post '/games', headers: headers
        uuid = JSON.parse(response.body).dig('game', 'uuid')
        game = Game.find_by(uuid: uuid)
        expect(game.max_attempts).to eq(6)
        expect(game.word_length).to eq(5)
        expect(game.max_words).to eq(25)
      end
    end

    context 'with valid params' do
      let(:config) { { max_attempts: 4, word_length: 3, max_words: 10 } }

      it 'creates a Game with the correct configuration' do
        post '/games', params: { game: config }.to_json, headers: headers
        uuid = JSON.parse(response.body).dig('game', 'uuid')
        game = Game.find_by(uuid: uuid)
        expect(game.max_attempts).to eq(4)
        expect(game.word_length).to eq(3)
        expect(game.max_words).to eq(10)
      end

      it 'returns the configuration in the response' do
        post '/games', params: { game: config }.to_json, headers: headers
        expect(JSON.parse(response.body)['game']).to include(config.stringify_keys)
      end
    end

    context 'with invalid params' do
      let(:config) { { max_attempts: 1 } }

      it 'returns a 422' do
        post '/games', params: { game: config }.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a Game' do
        expect do
          post '/games', params: { game: config }.to_json, headers: headers
        end.not_to change(Game, :count)
      end
    end
  end
end
