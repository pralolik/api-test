class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.belongs_to :variant
      t.text :question_text
      t.string :question_type
      t.integer :question_point

      t.timestamps
    end
  end
end
