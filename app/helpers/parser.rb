module Parser
	require 'nokogiri'
	require 'mechanize'

	#retrieves and parses the xml returned by the EAGLE search
	#yeah, okay, it isn't a helper... I don't want to put it in lib though...
	def get_and_parse(query)
		@agent = set_agent
		debugger
		search_url = "http://search.eagle.research-infrastructures.eu/solr/EMF-index-cleaned/select?group=true&group.field=tmid&start=0&rows=1&fl=*&q=(#{query})"
		response = @agent.get(search_url)
		if respo
		#actual result is in the str returned
		t = response.search("//arr[@name='__result']/str")
		num_matches = response.search("//int[@name='matches']").content.to_i
		if num_matches > 100
			#gotta get all the results from solr
		end

	end
	def parse_result(record)
		
			text = record.content
			xml = Nokogiri::XML::Document.parse(text, &:noblanks)
			#remove namespaces for simplicity
			xml.remove_namespaces!
			#pull out everything needed for db
			#0 queryTerms, 1 title, 2 entityType, 3 source, 4 sourceUrl, 5 tmId, 6 notBeforeDate, 7 notAfterDate,
      #8 period, 9 findRomanProvence, 10 findAncientSpot, 11 findModernSpot, 12 findModernCountry,
      #13 findModernRegion, 14 findModerProvence, 15 inscriptionType, 16 objectType, 17 material, 18 transcription, 19 description
      
      #take care of query terms seperately (own table)

      db = Hash.new
      db["title"] = record.search(".//title").content if record.search(".//title")
      db["entityType"] = record.search(".//entityType").content if record.search(".//entityType")
      
      source_info = record.search(".//recordSourceInfo")
      if source_info
       	db["source"] = source_info.attribute("providerName").value
       	db["sourceUrl"] = source_info.attribute("landingPage").value
	    end
      
      db["tmId"] = source.search(".//tmId").content if source.search(".//tmId")
      
      date_info = record.search(".//originDating")
      if date_info
	     	db["notBeforeDate"] = date_info.attribute("notBefore").value
	     	db["notAfterDate"] = date_info.attribute("notAfter").value
	     	db["period"] = date_info.attribute("period").value
    	end

    	db["findRomanProvence"] = record.search(".//romanProvinceItalicRegion").content if record.search(".//romanProvinceItalicRegion")
    	db["findAncientSpot"] = record.search(".//ancientFindSpot").content if record.search(".//ancientFindSpot")
    	db["findModernSpot"] = record.search(".//modernFindSpot").content if record.search(".//modernFindSpot")
    	db["findModernCountry"] = record.search(".//modernCountry").content if record.search(".//modernCountry")
    	db["findModernRegion"] = record.search(".//modernRegion").content if record.search(".//modernRegion")
    	db["findModerProvence"] = record.search(".//modernProvence").content if record.search(".//modernProvence")

    	i_types = []
    	record.search(".//inscriptionType").each do |type|
    		i_types << type.content
    	end
    	db["inscriptionType"] = i_types.join(';')
    	
    	db["objectType"] = record.search(".//objectType").content if record.search(".//objectType")
    	db["material"] = record.search(".//material").content if record.search(".//material")
    	db["transcription"] = record.search(".//transcription/text").content if record.search(".//transcription/text")
    	db["description"] = record.search(".//description").content if record.search(".//description")


		end

		puts "placeholder"
	end


	def set_agent(a_alias = 'Mac Safari')
    @agent = Mechanize.new
    @agent.user_agent_alias= a_alias
    return @agent
  end

end