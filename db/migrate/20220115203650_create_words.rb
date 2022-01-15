class CreateWords < ActiveRecord::Migration[7.0]
  def change
    create_table :words do |t|
      t.string :to_guess, null: :false
      t.integer :score, null: false, default: 0
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
