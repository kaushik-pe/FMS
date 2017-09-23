class AddClassnameToBookings < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :classname, :string
  end
end
