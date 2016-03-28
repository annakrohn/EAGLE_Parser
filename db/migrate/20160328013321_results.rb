class Results < ActiveRecord::Migration
  def change
  	execute <<-SQL
      ALTER TABLE `eagle_parse`.`results` 
      ADD CONSTRAINT `query_key`
      FOREIGN KEY (`queryTerms` )
      REFERENCES `eagle_parse`.`terms` (`id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `query_key_idx` (`queryTerms` ASC) ;
    SQL
  end
end
