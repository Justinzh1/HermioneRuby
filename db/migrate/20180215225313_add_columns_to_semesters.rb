class AddColumnsToSemesters < ActiveRecord::Migration[5.1]

  def change
  	add_column :semesters, :folder_id, :string
  	add_column :semesters, :year, :string
  end
  
end
