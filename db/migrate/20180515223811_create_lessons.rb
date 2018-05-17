class CreateLessons < ActiveRecord::Migration[5.2]
  def change
    create_table :lessons do |t|
      t.belongs_to :user
      t.string :lesson_name
      t.string :lesson_type

      t.timestamps
    end

    create_table :groups_lessons, id: false do |t|
      t.belongs_to :group, index: true
      t.belongs_to :lesson, index: true
    end
  end
end
