class ChangeTypeIdToString < ActiveRecord::Migration[5.1]
  def change
  	change_column :videos, :box_id, :string
  end
end
