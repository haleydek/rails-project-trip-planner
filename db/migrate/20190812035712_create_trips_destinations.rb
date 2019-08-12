class CreateTripsDestinations < ActiveRecord::Migration[5.2]
  def change
    create_table :trips_destinations do |t|
      t.integer :trip_id
      t.integer :destination_id
    end
  end
end
