module Parser
	require 'nokogiri'
	require 'mechanize'

	#retrieves and parses the xml returned by the EAGLE search
	#yeah, okay, it isn't a helper... I don't want to put it in lib though...
	
#The overall idea is to get the solr results in batches of 100, parse the XML into
#a hash, collect all of the hashes in an array, then the array gets passed back 
#to the model for actual row creation based off of each hash


  def get_and_parse(query)
		@agent = set_agent
		debugger
    #this array is what gets passed back to the result model
    arr_of_records = []
    start_row = 0
    #a starting value to get things going
    num_matches = 1
    while num_matches > start_row
      groups = get_result(query, start_row)     
      if groups
        #actual results are in a str, iterate to grab them
        records = groups.search("//arr[@name='__result']/str")
        records.each do |record|
          arr_of_records << parse_result(record)
        end
      else
        #if nothing is returned from the search do nothing
      end
      #get the actual number of matches returned
      num_matches = groups.search("//int[@name='matches']").content.to_i
      #100 rows returned at a time, so add that much for next round, 
      #makes sure there is an end to the while loop
      start_row = start_row + 100
    end
    if num_matches > 0
      res_text = "#{num_matches} records parsed"
    else
      res_text = "No records returned"
    end
    return arr_of_records, res_text
	end

  def get_result(query, start_row)
    search_url = "http://search.eagle.research-infrastructures.eu/solr/EMF-index-cleaned/select?group=true&group.field=tmid&start=#{start_row}&rows=100&fl=*&q=(#{query})"
    response = @agent.get(search_url)
    #if arr[@name='groups'] has content, then it has returned values
    groups = response.search("//arr[@name='groups']")
    unless groups.children.empty?
      return groups
    else
      return nil
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


		return db
	end


	def set_agent(a_alias = 'Mac Safari')
    @agent = Mechanize.new
    @agent.user_agent_alias= a_alias
    return @agent
  end

end