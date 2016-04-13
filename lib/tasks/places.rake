
desc "get coordinates for places"
task :get_coords => :environment do
	places = Place.all
	places.each do |place|
		Place.get_lat_and_long(place)
	end
end

desc "make csv"
task :make_csv => :environment do
	query = Term.where(id: 1).first
	search = "title rlike :t or inscriptionType rlike :t or transcription rlike :t or description rlike :t or cleanTranscription rlike :t"
	arr = query.query_terms.split(/\sOR\s/)
	arr.each do |term|
		place_ids_arr = Result.select(:findRomanProvence, :findAncientSpot, :findModernSpot, :findModernCountry, :findModernRegion, :findModernProvence).where(search, {t: term})
		place_ids_arr.each do |place|
			debugger
			coords = Place.select(:lat, :long).where(id: place.id)
		end
	end
end