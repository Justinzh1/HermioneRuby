class AddFolderIdToCourses < ActiveRecord::Migration[5.1]
  def change
  	add_column :courses, :folder_id, :string
  end
end
