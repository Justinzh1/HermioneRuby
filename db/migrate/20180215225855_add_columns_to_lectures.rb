class AddColumnsToLectures < ActiveRecord::Migration[5.1]
  def change
  	add_column :lectures, :folder_id, :string
  	add_column :lectures, :date, :date
  end
end
