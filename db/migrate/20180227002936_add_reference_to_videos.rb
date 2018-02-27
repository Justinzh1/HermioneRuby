class AddReferenceToVideos < ActiveRecord::Migration[5.1]
  def change
  	add_reference :videos, :semester, index: true
  end
end
