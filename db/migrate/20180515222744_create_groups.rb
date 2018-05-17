class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.integer :group_type
      t.integer :group_number
      t.date :year_of_receipt

      t.timestamps
    end

    add_index :groups, [:group_type, :group_number, :year_of_receipt], unique: true

    create_table :groups_users, id: false do |t|
      t.belongs_to :group, index: true
      t.belongs_to :user, index: true
    end
  end
end
