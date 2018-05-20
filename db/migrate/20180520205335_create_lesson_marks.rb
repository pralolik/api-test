class CreateLessonMarks < ActiveRecord::Migration[5.2]
  def change
    create_table :lesson_marks do |t|
      t.belongs_to :lesson
      t.integer :marks_count
      t.text :marks_template
      t.boolean :is_visible_to_student

      t.timestamps
    end
  end
end
