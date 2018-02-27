class AddReferenceToSemesters < ActiveRecord::Migration[5.1]
  def change
  	add_reference :semesters, :videos, index: true
  end
end
