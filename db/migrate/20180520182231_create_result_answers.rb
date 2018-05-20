class CreateResultAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :result_answers do |t|
      t.belongs_to :user
      t.belongs_to :result
      t.belongs_to :question
      t.belongs_to :question_select
      t.text :question_answer_text
      t.boolean :is_valid
      t.boolean :is_checked

      t.timestamps
    end
  end
end
