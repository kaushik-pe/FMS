class CreatePassengers < ActiveRecord::Migration[5.1]
  def change
    create_table :passengers do |t|
      t.string :name
      t.string :aadharno
      t.integer :age

      t.timestamps
    end
  end
end
