class AddNamesToProfessors < ActiveRecord::Migration[5.1]
  def change
  	add_column :professors, :name, :string
  end
end
