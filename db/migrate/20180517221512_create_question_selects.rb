class CreateQuestionSelects < ActiveRecord::Migration[5.2]
  def change
    create_table :question_selects do |t|
      t.belongs_to :question
      t.string :select_text
      t.boolean :is_valid

      t.timestamps
    end
  end
end
