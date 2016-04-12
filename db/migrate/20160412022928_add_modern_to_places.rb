class AddModernToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :modern, :boolean
  end
end
