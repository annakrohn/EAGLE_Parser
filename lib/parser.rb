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

    #this array is what gets passed back to the result model
    arr_of_records = []

    groups = get_result(query)     
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
    num_matches = groups.search("//int[@name='matches']").inner_text.to_i

    if num_matches > 0
      res_text = "#{num_matches} records parsed"
    else
      res_text = "No records returned"
    end
    return arr_of_records, res_text
	end

  def get_result(query)
    search_url = "http://search.eagle.research-infrastructures.eu/solr/EMF-index-cleaned/select?group=true&group.field=tmid&start=0&rows=300&fl=*&q=(#{query})"

    response = @agent.get(search_url)

    #if arr[@name='groups'] has inner_text, then it has returned values
    groups = response.search("//arr[@name='groups']")
    unless groups.children.empty?
      return groups
    else
      return nil
    end
  end

	def parse_result(record)
		begin
  		text = record.content
  		xml = Nokogiri::XML::Document.parse(text, &:noblanks)
  		#remove namespaces for simplicity
  		xml.remove_namespaces!
  		#pull out everything needed for db
  		#0 queryTerms, 1 title, 2 entityType, 3 source, 4 sourceUrl, 5 tmId, 6 notBeforeDate, 7 notAfterDate,
      #8 period, 9 findRomanProvence, 10 findAncientSpot, 11 findModernSpot, 12 findModernCountry,
      #13 findModernRegion, 14 findModernProvence, 15 inscriptionType, 16 objectType, 17 material, 18 transcription, 19 description
      
      #take care of query terms seperately (own table)

      db = Hash.new
      db[:title] = xml.search(".//title").inner_text.strip 
      db[:title] = xml.search(".//artifactTitle").inner_text.strip if db[:title] == ""
      db[:entityType] = xml.search(".//entityType").inner_text.strip
      
      source_info = xml.search(".//recordSourceInfo")

      unless source_info.empty?
       	db[:source] = source_info.attribute("providerName").value
       	db[:sourceUrl] = source_info.attribute("landingPage").value
      else
        db[:source] = ""
        db[:sourceUrl] = ""
      end
      
      db[:tmId] = xml.search(".//tmId").inner_text.strip 

      date_info = xml.search(".//originDating")
      unless date_info.empty?
       	db[:notBeforeDate] = date_info.attribute("notBefore").value
       	db[:notAfterDate] = date_info.attribute("notAfter").value
       	db[:period] = date_info.attribute("period").value
      else
        db[:notBeforeDate] = ""
        db[:notAfterDate] = ""
        db[:period] = ""
    	end

    	db[:findRomanProvence] = add_places(xml.search(".//romanProvinceItalicRegion").inner_text.strip, false) 
    	db[:findAncientSpot] = add_places(xml.search(".//ancientFindSpot").inner_text.strip, false) 
    	db[:findModernSpot] = add_places(xml.search(".//modernFindSpot").inner_text.strip, true) 
    	db[:findModernCountry] = add_places(xml.search(".//modernCountry").inner_text.strip, true) 
    	db[:findModernRegion] = add_places(xml.search(".//modernRegion").inner_text.strip, true)
    	db[:findModernProvence] = add_places(xml.search(".//modernProvence").inner_text.strip, true) 

      #keep an eye on this, could go funky if search is empty
    	i_types = []
    	xml.search(".//inscriptionType").each do |type|
    		i_types << type.inner_text.strip
    	end
    	db[:inscriptionType] = i_types.join(';')
    	db[:objectType] = xml.search(".//objectType").inner_text.strip 
    	db[:material] = xml.search(".//material").inner_text.strip 
      #multiple possibilities for the transcriptions
      transcription = xml.search(".//hasTranscription/text")
      if transcription.empty?
        db[:transcription] = xml.search(".//transcription/text").inner_text.strip 
      else
        db[:transcription] = transcription.inner_text.strip
      end
      
    	db[:description] = xml.search(".//description").inner_text.strip 


  		return db
    rescue Exception => e
      puts "Something went wrong! #{$!}" 
      puts e.backtrace
    end  
	end


  def add_places(raw_string, modern_bool)
    unless raw_string == "" || raw_string == nil
      already_there = Place.find_by(name: raw_string)
      unless already_there
        new_place = Place.create(name: raw_string, modern: modern_bool)
        p_index = new_place.id
      end
    else
      p_index = nil
    end
    return p_index
  end


	def set_agent(a_alias = 'Mac Safari')
    @agent = Mechanize.new
    @agent.user_agent_alias= a_alias
    return @agent
  end

end