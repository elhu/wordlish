require 'swagger_helper'

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

  describe 'OpenAPI documentation' do
    path "/games/{game_uuid}/attempts" do
      post('Create a new attempt for the current word of the current game') do
        tags 'Attempts'
        consumes 'application/json'
        produces 'application/json'
        description <<~DESC
          TBD
        DESC
        parameter name: :game_uuid, in: :path, type: :string, description: "UUID of the game", example: "sOqmDethcUawYzhIprwk"
        parameter name: :attempt, in: :body, schema: {
          properties: {
            attempt: {
              type: :object,
              description: "New attempt for the current word of the current game",
              properties: {
                guess: {
                  description: "Your guess",
                  example: "sword",
                  type: :string
                }
              },
              required: [:guess]
            }
          },
          required: [:attempt]
        }

        response(201, 'Attempt Registered') do
          schema type: :object,
                 properties: {
                   game: {
                     type: :object,
                     description: "State of the game",
                     properties: {
                       score: { type: :integer, example: 42, description: "Score (if game is done)" },
                       status: { type: :string, example: "done", description: "Status of the word currently being played" },
                       current_word: {
                         type: :object,
                         properties: {
                           status: { type: :string, example: "done", description: "DONE|ONGOING" },
                           success: { type: :boolean, example: true, description: "Wether or not you've won the word" },
                           attempts: {
                             type: :array,
                             description: "List of attempts for the given word so far (most recent last)",
                             items: {
                               type: :object,
                               properties: {
                                 guess: { type: :string, example: "sword", description: "Guess submitted in the API call" },
                                 letters: {
                                   type: :array,
                                   description: "List of letters in the latest guess and their result",
                                   items: {
                                     type: :object,
                                     properties: {
                                       letter: { type: :string, example: "s", description: "Letter that was guessed for given position" },
                                       result: { type: :string, example: "wrong_position", description: "Result for that letter" }
                                     },
                                     required: [:letter, :result]
                                   }
                                 }
                               },
                               required: [:guess, :letters]
                             }
                           }
                         },
                         required: [:status, :success, :attempts]
                       }
                     },
                     required: [:status, :current_word]
                   }
                 },
                 required: [:game]

          let(:game_uuid) { Game.create.uuid }
          let(:attempt) { { guess: "sword" } }
          run_test!
        end

        response(422, 'Invalid guess') do
          schema type: :object,
                 properties: {
                   errors: {
                     type: :object,
                     description: "Info about the errors"
                   }
                 },
                 required: [:errors]

          let(:game_uuid) { Game.create.uuid }
          let(:attempt) { { guess: "word" } }
          run_test!
        end
      end
    end
  end
end
