class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :query_terms

      t.timestamps
    end
  end
end
