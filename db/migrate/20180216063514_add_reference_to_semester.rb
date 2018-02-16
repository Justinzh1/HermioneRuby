class AddReferenceToSemester < ActiveRecord::Migration[5.1]
  def change
  	add_reference :semesters, :course, index: true
  end
end
