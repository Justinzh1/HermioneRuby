class AddPathAndIdToVideos < ActiveRecord::Migration[5.1]
  def change
  	add_column :videos, :box_id, :integer
  	add_column :videos, :path, :string
  end
end
