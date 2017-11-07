class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :description
      t.string :code
      t.string :year
      t.string :semester

      t.timestamps
    end
  end
end
