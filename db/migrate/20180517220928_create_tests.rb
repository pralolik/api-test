class CreateTests < ActiveRecord::Migration[5.2]
  def change
    create_table :tests do |t|
      t.belongs_to :lesson
      t.string :test_name
      t.boolean :is_active
      t.string :type_of_variant
      t.integer :variants_count
      t.date :due_date

      t.timestamps
    end
  end
end
