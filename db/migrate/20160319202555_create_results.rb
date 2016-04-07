class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :queryTerms
      t.string :title
      t.string :entityType
      t.string :source
      t.string :sourceUrl
      t.string :tmId
      t.integer :notBeforeDate
      t.integer :notAfterDate
      t.string :period
      t.string :findRomanProvence
      t.string :findAncientSpot
      t.string :findModernSpot
      t.string :findModernCountry
      t.string :findModernRegion
      t.string :findModerProvence
      t.string :inscriptionType
      t.string :objectType
      t.string :material
      t.text :transcription, :limit => 2147483647
      t.timestamps
    end
  end
end
