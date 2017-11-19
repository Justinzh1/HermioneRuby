class CreateVideos < ActiveRecord::Migration[5.1]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :url
      t.decimal :length

      t.timestamps
    end
  end
end
