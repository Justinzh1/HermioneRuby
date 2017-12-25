class AddAbbrevToVideos < ActiveRecord::Migration[5.1]
  def change
  	add_column :courses, :abbrev, :string
  end
end
