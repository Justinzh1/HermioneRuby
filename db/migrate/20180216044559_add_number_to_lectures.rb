class AddNumberToLectures < ActiveRecord::Migration[5.1]
  def change
  	add_column :lectures, :number, :integer
  end
end
