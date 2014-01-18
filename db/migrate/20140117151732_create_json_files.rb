class CreateJsonFiles < ActiveRecord::Migration
  def change
    create_table :json_files do |t|
      t.string :name
      t.datetime :updated
      t.text :json

      t.timestamps
    end
  end
end
