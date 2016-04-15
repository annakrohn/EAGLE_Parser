
desc "get coordinates for places"
task :get_coords => :environment do
	places = Place.all
	places.each do |place|
		if place[:lat] != nil && place[:lat] != ""
			puts "Skipping #{place[:name]}"
		else
			Place.get_lat_and_long(place)
		end
	end
end

desc "make csv"
task :make_csv => :environment do
	query = Term.where(id: 3).first
	search = "(queryTerms = :n and title rlike :t) or 
						(queryTerms = :n and inscriptionType rlike :t) or
						(queryTerms = :n and description rlike :t) or 
						(queryTerms = :n and cleanTranscription rlike :t)"
	arr = query.query_terms.split(/\sOR\s/)
	a_list = []
	m_list = []
	
	arr.each do |term|
		place_ids_arr = Result.where(search, {t: term, n: query[:id].to_i})
		a_term = []
		m_term = []
		place_ids_arr.each do |place|
			a_lat, a_long, m_lat, m_long = nil
			if place[:findAncientSpot] != "" && place[:findAncientSpot] != nil
				row = Place.find(place[:findAncientSpot])
				a_name = row[:name]
				a_lat = row[:lat]
				a_long = row[:long]
			elsif place[:findRomanProvence] != "" && place[:findRomanProvence] != nil
				row = Place.find(place[:findRomanProvence])
				a_name = row[:name]
				a_lat = row[:lat]
				a_long = row[:long]
			end

			if place[:findModernSpot] != "" && place[:findModernSpot] != nil
				row = Place.find(place[:findModernSpot])
				m_name = row[:name]
				m_name.gsub!(",", "") if m_name =~ /\w,\s/
				m_lat = row[:lat]
				m_long = row[:long]
			elsif place[:findModernCountry] != "" && place[:findModernCountry] != nil
				row = Place.find(place[:findModernCountry])
				m_name = row[:name]
				m_name.gsub!(",", "") if m_name =~ /\w,\s/
				m_lat = row[:lat]
				m_long = row[:long]
			elsif place[:findModernRegion] != "" && place[:findModernRegion] != nil
				row = Place.find(place[:findModernRegion])
				m_name = row[:name]
				m_name.gsub!(",", "") if m_name =~ /\w,\s/
				m_lat = row[:lat]
				m_long = row[:long]
			elsif place[:findModernProvence] != "" && place[:findModernProvence] != nil
				row = Place.find(place[:findModernProvence])
				m_name = row[:name]
				m_name.gsub!(",", "") if m_name =~ /,/
				m_lat = row[:lat]
				m_long = row[:long]
			end

			i_tag = case place[:inscriptionType]
			when /honorarius|ehreninschrift|honorific/ then "honorific"
			when /sacer|weihinschrift/ then "votive"
			when /estampilla|sepulcralis|sepulcral|memorial|grabinschrift/	then "funerary"
			when /stifterinschrift|oper. publ. priv.que/ then "dedicatory"
			when /fasti|ley/ then "legal"
			end

			o_tag = case place[:objectType]
			when /cipo|cippus|vaso/ then "funerary"
			when /aedificium|wall/ then "graffiti"
			end

			tag = o_tag ? o_tag : i_tag

			if a_lat
				a_list << [term, "\"#{place[:objectType]}\"", "\"#{place[:inscriptionType]}\"", "\"#{place[:transcription]}\"", "\"#{a_name}\"", a_lat, a_long, tag] 
#				a_list << [term, place[:id], a_name, a_lat, a_long]
#				a_term << [term, place[:objectType], place[:inscriptionType], place[:transcription], a_name, a_lat, a_long]
			end
			if m_lat
				m_list << [term, "\"#{place[:objectType]}\"", "\"#{place[:inscriptionType]}\"", "\"#{place[:transcription]}\"", "\"#{m_name}\"", m_lat, m_long, tag]
#				m_list << [term, place[:id], m_name, m_lat, m_long]
#				m_term << [term, place[:objectType], place[:inscriptionType], place[:transcription], m_name, m_lat, m_long]
			end

		end
#		unless a_term.empty? 
#			a_file = File.new("#{BASE_DIR}/eagle_parse/lib/assets/csv/#{term}_a.csv", "w")
#			a_file << "Term, Object Type, Inscription Type, Inscription, Ancient Place Name, Ancient Latitude, Ancient Longitude\n"
#			a_term.each {|row| a_file << row.join(',').force_encoding("UTF-8") + "\n"}
#			a_file.close	
#		end
#		unless m_term.empty?
#			m_file = File.new("#{BASE_DIR}/eagle_parse/lib/assets/csv/#{term}_m.csv", "w")
#			m_file << "Term, Object Type, Inscription Type, Inscription, Modern Place Name, Modern Latitude, Modern Longitude\n"
#			m_term.each {|row| m_file << row.join(',').force_encoding("UTF-8") + "\n"}
#			m_file.close
#		end
	end
	a_coord = File.new("#{BASE_DIR}/eagle_parse/lib/assets/csv/a_coords.csv", "w")
	m_coord = File.new("#{BASE_DIR}/eagle_parse/lib/assets/csv/m_coords.csv", "w")
	a_coord << "Term, Object Type, Inscription Type, Inscription, Place Name, Latitude, Longitude, Tag\n"
	m_coord << "Term, Object Type, Inscription Type, Inscription, Place Name, Latitude, Longitude, Tag\n"
	a_list.each {|row| a_coord << row.join(',').force_encoding("UTF-8") + "\n"}
	m_list.each {|row| m_coord << row.join(',').force_encoding("UTF-8") + "\n"}
	a_coord.close
	m_coord.close

end