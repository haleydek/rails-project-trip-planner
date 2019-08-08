class CreateUsersTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :users_trips do |t|
      t.integer :user_id
      t.integer :trip_id
      t.boolean :trip_admin, default: false

      t.timestamps
    end
  end
end
