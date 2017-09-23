class AddBookingnoToBookings < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :bookingno, :string
  end
end
