class AddPositionToWord < ActiveRecord::Migration[7.0]
  def change
    add_columns :words, :position, type: :integer, null: false
  end
end
