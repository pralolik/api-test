class CreateVariants < ActiveRecord::Migration[5.2]
  def change
    create_table :variants do |t|
      t.belongs_to :test
      t.string :variant_text

      t.timestamps
    end
  end
end
