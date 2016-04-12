class UpdateResultsChangePlaceColumnsToKeys < ActiveRecord::Migration
  def change
    change_column :results, :findRomanProvence, :integer
    change_column :results, :findAncientSpot, :integer
    change_column :results, :findModernSpot, :integer
    change_column :results, :findModernCountry, :integer
    change_column :results, :findModernRegion, :integer
    change_column :results, :findModernProvence, :integer

    execute <<-SQL
      ALTER TABLE `eagle_parse`.`results` 
      ADD CONSTRAINT `r_prov_key`
      FOREIGN KEY (`findRomanProvence` )
      REFERENCES `eagle_parse`.`places` (`id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `r_prov_idx` (`findRomanProvence` ASC) ;
    SQL

    execute <<-SQL
      ALTER TABLE `eagle_parse`.`results` 
      ADD CONSTRAINT `a_spot_key`
      FOREIGN KEY (`findAncientSpot` )
      REFERENCES `eagle_parse`.`places` (`id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `a_spot_idx` (`findAncientSpot` ASC) ;
    SQL

    execute <<-SQL
      ALTER TABLE `eagle_parse`.`results` 
      ADD CONSTRAINT `m_spot_key`
      FOREIGN KEY (`findModernSpot` )
      REFERENCES `eagle_parse`.`places` (`id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `m_spot_idx` (`findModernSpot` ASC) ;
    SQL

    execute <<-SQL
      ALTER TABLE `eagle_parse`.`results` 
      ADD CONSTRAINT `m_country_key`
      FOREIGN KEY (`findModernCountry` )
      REFERENCES `eagle_parse`.`places` (`id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `m_country_idx` (`findModernCountry` ASC) ;
    SQL

    execute <<-SQL
      ALTER TABLE `eagle_parse`.`results` 
      ADD CONSTRAINT `m_region_key`
      FOREIGN KEY (`findModernRegion` )
      REFERENCES `eagle_parse`.`places` (`id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `m_region_idx` (`findModernRegion` ASC) ;
    SQL

    execute <<-SQL
      ALTER TABLE `eagle_parse`.`results` 
      ADD CONSTRAINT `m_provence_key`
      FOREIGN KEY (`findModernProvence` )
      REFERENCES `eagle_parse`.`places` (`id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `m_provence_idx` (`findModernProvence` ASC) ;
    SQL
  end
end
