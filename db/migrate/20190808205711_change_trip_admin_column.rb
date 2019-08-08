class ChangeTripAdminColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :users_trips, :trip_admin, :boolean, null: false, default: false
  end
end
