class CreateGames < ActiveRecord::Migration[7.0]
  def up
    create_enum :game_status, ["ongoing", "done"]

    create_table :games do |t|
      t.string :uuid
      t.integer :score
      t.enum :status, enum_type: :game_status, default: "ongoing"

      t.timestamps
    end
    add_index :games, :uuid, unique: true
    add_index :games, :score
  end

  def down
    drop_table :games

    execute <<-SQL
     DROP TYPE game_status;
    SQL
  end
end
