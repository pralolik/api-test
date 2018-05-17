class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.belongs_to :user, index: true
      t.string :role_type

      t.timestamps
    end
  end
end
