class AddSeedToGame < ActiveRecord::Migration[7.0]
  def change
    add_columns :games, :seed, type: :string, null: false
  end
end
