class CreateFlighttypes < ActiveRecord::Migration[5.1]
  def change
    create_table :flighttypes do |t|
      t.string :classname
      t.integer :noofseats
      t.integer :price
      t.references :flight, foreign_key: true

      t.timestamps
    end
  end
end
