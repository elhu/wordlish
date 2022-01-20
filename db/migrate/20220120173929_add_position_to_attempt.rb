class AddPositionToAttempt < ActiveRecord::Migration[7.0]
  def change
    add_columns :attempts, :position, type: :integer, null: false
  end
end
