module Parser
	require 'nokogiri'
	require 'mechanize'

	#retrieves and parses the xml returned by the EAGLE search
	#yeah, okay, it isn't really a helper
	def get_and_parse(query)
		@agent = set_agent
		debugger
		search_url = "http://search.eagle.research-infrastructures.eu/solr/EMF-index-cleaned/select?group=true&group.field=tmid&start=0&rows=1&fl=*&q=(#{query})"
		response = @agent.get(search_url)
		#the response structure is such that what we want is a string, so we have to isolate that then turn the
		#string into xml to make it easier to work with, as xpath is far nicer than wrangling with a string
		t = response.search("//arr[@name='__result']/str")
		t.children.each do |record|
			text = record.content
			xml = Nokogiri::XML::Document.parse(text)
			#remove namespaces for simplicity
			xml.remove_namespaces!
			#pull out everything needed for db
			
		end

		puts "placeholder"
	end


	def set_agent(a_alias = 'Mac Safari')
    @agent = Mechanize.new
    @agent.user_agent_alias= a_alias
    return @agent
  end

end