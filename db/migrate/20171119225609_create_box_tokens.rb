class CreateBoxTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :box_tokens do |t|
      t.string :token
      t.time :time

      t.timestamps
    end
  end
end
