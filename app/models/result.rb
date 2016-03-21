class Result < ActiveRecord::Base
	extend Parser

	
  
	def self.eagle_search(params)
		
		Result.get_and_parse(params[:search_terms])

	end

end
