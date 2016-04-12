class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.string :lat
      t.string :long

      t.timestamps
    end
  end
end
