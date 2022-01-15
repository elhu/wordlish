require 'swagger_helper'

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
      let(:seed) { "LMdflkdSrlcz6RkO2OFvfQ==\n" }
      let(:config) { { max_attempts: 4, word_length: 3, max_words: 10, seed: seed } }

      it 'creates a Game with the correct configuration' do
        post '/games', params: { game: config }.to_json, headers: headers
        uuid = JSON.parse(response.body).dig('game', 'uuid')
        game = Game.find_by(uuid: uuid)
        expect(game.max_attempts).to eq(4)
        expect(game.word_length).to eq(3)
        expect(game.max_words).to eq(10)
        expect(game.seed).to eq(seed)
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

  describe 'OpenAPI documentation' do
    path '/games' do
      post('Create a new game') do
        tags 'Games'
        consumes 'application/json'
        produces 'application/json'
        description <<~DESC
          This endpoint creates a new game.
          If no parameters are given, the following configuration is used:
          * 25 words to guess
          * words are 5 letters long
          * you get 6 attempts per words

          If you improved your guessing program and want to replay a past game,
          save the seed from that game and reuse it when creating a new one!
        DESC
        parameter name: :game, in: :body, schema: {
          properties: {
            game: {
              type: :object,
              description: "Configuration for the game",
              optional: true,
              properties: {
                max_attempts: {
                  description: "Number of attempts to guess each word",
                  default: 6,
                  minimum: 4,
                  maximum: 10,
                  type: :int
                },
                max_words: {
                  description: "Number of words to guess",
                  default: 25,
                  minimum: 10,
                  maximum: 50,
                  type: :int
                },
                seed: {
                  description: "Seed to use to generate the word list (to repeat previous games)",
                  type: :string
                },
                word_length: {
                  description: "Length of the words the guess",
                  default: 5,
                  minimum: 3,
                  maximum: 16,
                  type: :int
                }
              }
            }
          }
        }

        response(201, 'game created') do
          schema type: :object,
                 properties: {
                   game: {
                     type: :object,
                     description: "Game object with configuration",
                     properties: {
                       uuid: {
                         description: "UUID of your game, use that to play!",
                         example: "sOqmDethcUawYzhIprwk.",
                         type: :string
                       },
                       seed: {
                         description: "Seed used to generate the word list, use that to play the same game again",
                         example: "LMdflkdSrlcz6RkO2OFvfQ==",
                         type: :string
                       },
                       max_attempts: {
                         description: "Number of attempts to guess each word",
                         example: 6,
                         type: :integer
                       },
                       max_words: {
                         description: "Number of words to guess",
                         example: 25,
                         type: :integer
                       },
                       word_length: {
                         description: "Length of the words the guess",
                         example: 5,
                         type: :integer
                       }
                     },
                     required: [:uuid, :seed, :max_attempts, :max_words, :word_length]
                   }
                 },
                 required: [:game]
          let(:game) { { max_words: 10 } }
          run_test!
        end
      end
    end
  end
end
