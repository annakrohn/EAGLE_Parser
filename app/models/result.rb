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
		#Rake::Task["get_coords"].execute
		return query.id
	end

	def self.analysis(params)
		query_id = params[:id]
		query = Term.where(id: query_id).first
		q_parts = query.query_terms.split(/\sOR\s/)
		collector = []
		rev_objs = {}
		tags = {}
		search = "(queryTerms = :n and title rlike :t) or 
							(queryTerms = :n and inscriptionType rlike :t) or
							(queryTerms = :n and description rlike :t) or 
							(queryTerms = :n and cleanTranscription rlike :t)"
		q_parts.each do |term|
			arr = Result.where(search, {t: term, n: query_id.to_i})
			obj_types = Result.where(search, {t: term, n: query_id.to_i}).group(:objectType).count
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
=begin			
			arr.each do |row|
				i_tag = case row[:inscriptionType]
				when /honorarius|ehreninschrift|honorific/ then "honorific"
				when /sacer|weihinschrift/ then "votive"
				when /estampilla|sepulcralis|sepulcral|memorial|grabinschrift/	then "funerary"
				when /stifterinschrift|oper. publ. priv.que/ then "dedicatory"
				when /fasti|ley/ then "legal"
				end

				o_tag = case row[:objectType]
				when /cipo|cippus|vaso/ then "funerary"
				when /aedificium|wall/ then "graffiti"
				end

				t_tag = case row[:cleanTranscription]
				when /dis manibus|hic situs est/i then "funerary"
				end

				tag = o_tag ? o_tag : i_tag
				tag = t_tag ? t_tag : tag
				if tags.key?(tag)
					if tags[tag][term].key?(row[:objectType])
					tags[tag][term] << [row[:objectType], row[:id]]
				else
					tags[tag] = {term => {row[:objectType] => 1}}
				end
			end
=end			
			hsh = {term_id: term, arr: arr, obj_types: obj_types}
			collector << hsh
		end
		sorted = collector.sort{|x, y| y[:arr].count <=> x[:arr].count}
		sorted_rev_objs = Hash[rev_objs.sort]
		return sorted, sorted_rev_objs
	end


end
