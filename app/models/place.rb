class Place < ActiveRecord::Base
	has_many :result
	include Parser

	def self.get_lat_and_long(p_name)
		#remove any parens or dashes and the text that they contain or that follows
		#not worrying about bounding boxes for regions right now, just get a representative point
		#if modern == true, go google
		#else go pleiades
		#if nothing found cut down to first word
		#if still nothing move on
		#save coordinates
		
	end

	def google_geocode_search(p_name)
		url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{p_name}&key=#{ENV[GOOGLE_GEO_API]}"
		#use "location" field
	end

	def pleiades_serch(p_name)
		#search in csv from pleiades for EXACT match
		#take 2nd column, the pleiades id
		#get the json info for place via the id
		
		url = "http://pleiades.stoa.org/places/#{pl_id}/json"
		#use "reprPoint" to get coordinates
		#remember! lat and long are reversed coming from pleiades... 
	end

end
