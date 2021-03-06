class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :zip_code, null:false
      t.integer :prefectur, null:false
      t.string :city, null:false
      t.string :block, null:false
      t.string :building_name
      t.timestamps
    end
  end
end
