class AddDescriptionToResults < ActiveRecord::Migration
  def change
    add_column :results, :description, :text, :limit => 2147483647
  end
end
