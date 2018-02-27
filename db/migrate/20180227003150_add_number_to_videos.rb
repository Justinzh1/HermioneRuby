class AddNumberToVideos < ActiveRecord::Migration[5.1]
  def change
  	add_column :videos, :number, :integer
  	remove_column :videos, :box_id
  end
end
