class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :title
      t.string :entityType

      t.timestamps
    end
  end
end
