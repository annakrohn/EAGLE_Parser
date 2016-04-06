class Result < ActiveRecord::Base
	belongs_to :term
	extend Parser

	#stores all of the information retrieved from the EAGLE API
  
	def self.eagle_search(params)
		query = term.create(query_terms: params[:search_terms])
		results, res_text = Result.get_and_parse(params[:search_terms])
		unless results.empty?
			results.each do |result|
				res = Result.create(result)
				res.query_terms = query.id
				res.save
			end
		end
		return res_text
	end

end
