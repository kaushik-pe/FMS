class CreateFlights < ActiveRecord::Migration[5.1]
  def change
    create_table :flights do |t|
      t.time :arrival_time
      t.time :departure_time
      t.string :source
      t.string :destination
      t.string :airline

      t.timestamps
    end
  end
end
