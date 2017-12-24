class ModifyVideos < ActiveRecord::Migration[5.1]
  def change
  	add_column :videos, :description, :string
  	add_column :videos, :tags, :string, array: true, default: []
  	add_column :videos, :category_id, :integer
  	add_column :videos, :privacyStatus, :string
  end
end
