class Result < ActiveRecord::Base
	belongs_to :term
	extend Parser
	include Report

	#stores all of the information retrieved from the EAGLE API
  
	def self.eagle_search(params)
		query = Term.create(query_terms: params[:search_terms])
		results, res_text = Result.get_and_parse(params[:search_terms])
		unless results.empty?
			results.each do |result|
				res = Result.create(result)
				res.queryTerms = query.id
				res.save
			end
		end
		return query.id
	end

	def self.analysis(params)
		query_id = params[:id]
		query = Term.where(id: query_id).first
		q_parts = query.query_terms.split(/\sOR\s/)
		collector = []
		q_parts.each do |term|
			arr = Result.select(:title, :transcription, :description).where("title rlike :t or transcription rlike :t or description rlike :t", {t: term})
			hsh = {term_id: term, arr: arr}
			collector << hsh
		end
		return collector
	end

end
