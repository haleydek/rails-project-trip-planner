class AddRegionColumnToDestinations < ActiveRecord::Migration[5.2]
  def change
    add_column :destinations, :region, :string
  end
end
