class Result < ActiveRecord::Base
	belongs_to :term
	belongs_to :place
	extend Parser
	include Report

	#stores all of the information retrieved from the EAGLE API
  
	def self.eagle_search(params)
		search = params[:results][:search_terms]
		query = Term.create(query_terms: search)
		results, res_text = Result.get_and_parse(search)
		unless results.empty?
			results.each do |result|
				res = Result.create(result)
				res.queryTerms = query.id
				res.save
			end
		end
		#trigger rake for places
		return query.id
	end

	def self.analysis(params)
		query_id = params[:id]
		query = Term.where(id: query_id).first
		q_parts = query.query_terms.split(/\sOR\s/)
		collector = []
		q_parts.each do |term|
			arr = Result.select(:title, :inscriptionType, :transcription, :description).where("title rlike :t or inscriptionType rlike :t or transcription rlike :t or description rlike :t", {t: term})
			hsh = {term_id: term, arr: arr}
			collector << hsh
		end
		sorted = collector.sort{|x, y| y[:arr].count <=> x[:arr].count}
		return sorted
	end

	#For places favor in this order: 10 findAncientSpot, 11 findModernSpot, 12 findModernCountry,
      #13 findModernRegion, 14 findModerProvence 9 findRomanProvence, 

end
