class AddFolderIdToVideos < ActiveRecord::Migration[5.1]
  def change
  	add_column :videos, :folder_id, :string
  end
end
