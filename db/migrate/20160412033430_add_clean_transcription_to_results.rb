class AddCleanTranscriptionToResults < ActiveRecord::Migration
  def change
    add_column :results, :cleanTranscription, :text, :limit => 2147483647
  end
end
