class RemoveSemesterFromCourses < ActiveRecord::Migration[5.1]
  def change
  	remove_column :courses, :semester, :string
  end
end
