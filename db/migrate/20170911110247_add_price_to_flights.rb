class AddPriceToFlights < ActiveRecord::Migration[5.1]
  def change
    add_column :flights, :price, :integer
  end
end
