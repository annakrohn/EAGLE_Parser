class AddDescriptionToResults < ActiveRecord::Migration
  def change
    add_column :results, :description, :text
  end
end
