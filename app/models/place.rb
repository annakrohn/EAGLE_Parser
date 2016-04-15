class Place < ActiveRecord::Base
	has_many :result
	include Parser
	require 'mechanize'

	def self.get_lat_and_long(place)
		begin
			@agent = Mechanize.new
    	@agent.user_agent_alias = 'Mac Safari'
			p_name = place.name
			#remove any parens or dashes and the text that they contain or that follows
			clean_name = p_name.gsub(/\(.+|\s-.+|\?.+/, "").strip
			#not worrying about bounding boxes for regions right now, just get a representative point
			coord = Place.send_to_search(clean_name, place.modern)
			unless coord.empty?
				place[:lat] = coord[0]
				place[:long] = coord[1]
				place.save
			else
				#if nothing move on
			end
		rescue Exception => e
      puts "Something went wrong! #{$!}" 
      puts e.backtrace
    end 
	end

	def self.send_to_search(clean_name, modern)
		#if modern == true, go google
		if modern
				coord = Place.google_geocode_search(clean_name)
		else
			#else go pleiades
			coord = Place.pleiades_serch(clean_name)
		end
		return coord
	end


	def self.google_geocode_search(p_name)
		url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{p_name}&key=#{GOOGLE_GEO_API}"
		#use "location" field
		
    res = @agent.get(url)
    if res
    	json = JSON.parse(res.body)
    	lat = json["results"][0]["geometry"]["location"]["lat"]
    	long = json["results"][0]["geometry"]["location"]["lng"]
    	coord = [lat, long]
    else
			#return empty array if nothing
			coord = []
		end
		puts "got #{coord.join(',')} for #{p_name}"
		return coord
	end

	def self.pleiades_serch(p_name)
		#search in csv from pleiades for EXACT match
		pleiades = File.readlines("#{BASE_DIR}/eagle_parse/lib/assets/pleiadesplus2.csv")
		matches = pleiades.select{|line| line[/\b#{p_name}\b/i]}
		if matches.empty?
			#try again with just the first word
			p_name = p_name.split(/\s/)[0]
			matches = pleiades.select{|line| line[/\b#{p_name}\b/i]}
		end
		pl_id = ""
		coord = []
		matches.each do |match|
			arr = match.split(',')
			debugger if p_name == "Germania inferior"
			if arr[2] == p_name || arr[1] =~ /\b#{p_name.gsub(' ', '')}\b/i
				#probably not the best way to do this, but we're going with it
				unless arr[5] == '' 
					#if there is a latitude and longitude, grab and go
					#get rid of the \n from the latitude
					coord << arr[6].strip
					coord << arr[5]
					break
				else
					#use geonames service if no lat and long provided
					gn_id = arr[4]
					unless gn_id == ''
						gn_url = "http://api.geonames.org/get?geonameId=#{gn_id}&username=#{GN_UN}"
						res = @agent.get(gn_url)
						coord << res.search(".//lat").inner_text
						coord << res.search(".//lng").inner_text
						break
					end
				end
			end
		end
		puts "got #{coord.join(',')} for #{p_name}"
		return coord
	end

end
