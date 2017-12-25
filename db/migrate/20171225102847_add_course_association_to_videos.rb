class AddCourseAssociationToVideos < ActiveRecord::Migration[5.1]
  def change
  	add_column :videos, :course_id, :integer
  end
end
