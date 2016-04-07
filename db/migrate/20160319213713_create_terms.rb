class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.text :query_terms

      t.timestamps
    end
  end
end
