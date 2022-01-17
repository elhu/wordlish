class CreateAttempts < ActiveRecord::Migration[7.0]
  def change
    create_table :attempts do |t|
      t.string :guess, null: false
      t.references :word, null: false, foreign_key: true

      t.timestamps
    end
  end
end
