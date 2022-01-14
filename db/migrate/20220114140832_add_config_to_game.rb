class AddConfigToGame < ActiveRecord::Migration[7.0]
  def change
    add_columns :games, :max_words, type: :integer, null: false, default: 25
    add_columns :games, :max_attempts, type: :integer, null: false, default: 6
    add_columns :games, :word_length, type: :integer, null: false, default: 5
  end
end
