class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.belongs_to :user
      t.belongs_to :variant
      t.string :tmp_json
      t.date :end_date
      t.boolean :require_check
      t.integer :total_mark

      t.timestamps
    end
  end
end
