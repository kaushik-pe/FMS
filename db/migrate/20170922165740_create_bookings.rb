class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.string :seatno
      t.date :bookingdate
      t.string :status
      t.date :doj
      t.references :user, foreign_key: true
      t.references :passenger, foreign_key: true
      t.references :flight, foreign_key: true

      t.timestamps
    end
  end
end
