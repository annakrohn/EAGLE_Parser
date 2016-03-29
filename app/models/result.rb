class Result < ActiveRecord::Base
	extend Parser

	#stores all of the information retrieved from the EAGLE API
  
	def self.eagle_search(params)
		
		results = Result.get_results(params[:search_terms])
		t.children.each do |record|
			Result.parse_result(record)
		end
	end

end
