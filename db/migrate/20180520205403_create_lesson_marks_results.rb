class CreateLessonMarksResults < ActiveRecord::Migration[5.2]
  def change
    create_table :lesson_marks_results do |t|
      t.belongs_to :lesson_mark
      t.belongs_to :user
      t.text :marks_json

      t.timestamps
    end
  end
end
