class AddStatusToWords < ActiveRecord::Migration[7.0]
  def up
    create_enum :word_status, ["not_started", "ongoing", "done"]
    add_columns :words, :status, type: :enum, enum_type: :word_status, null: false, default: "not_started"
  end

  def down
    remove_column :words, :status

    execute <<-SQL
      DROP TYPE word_status;
    SQL
  end
end
