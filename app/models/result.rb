class Result < ActiveRecord::Base
	belongs_to :term
	belongs_to :place
	extend Parser
	include Report
	require 'rake'

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
		Rake::Task["get_coords"].execute
		return query.id
	end

	def self.analysis(params)
		query_id = params[:id]
		query = Term.where(id: query_id).first
		q_parts = query.query_terms.split(/\sOR\s/)
		collector = []
		rev_objs = {}
		search = "title rlike :t or inscriptionType rlike :t or transcription rlike :t or description rlike :t or cleanTranscription rlike :t"
		q_parts.each do |term|
			arr = Result.select(:title, :inscriptionType, :transcription, :description).where(search, {t: term})
			obj_types = Result.where(search, {t: term}).group(:objectType).count
			obj_types.each do |key, value|
				unless value == 0
					key = "[blank]" if key == ""
					if rev_objs.key?(key)
						rev_objs[key] << [term, value]
					else
						rev_objs[key] = [[term, value]]
					end
				end
			end
			hsh = {term_id: term, arr: arr, obj_types: obj_types}
			collector << hsh
		end
		sorted = collector.sort{|x, y| y[:arr].count <=> x[:arr].count}
		sorted_rev_objs = Hash[rev_objs.sort]
		return sorted, sorted_rev_objs
	end


end
