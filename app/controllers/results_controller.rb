class ResultsController < ApplicationController
	#controlling searches and displaying results
	def index
		@term_id = params["format"]
		@results = Result.where(queryTerms: @term_id)
		@count = Result.where(queryTerms: @term_id).count
		return @count, @term_id
	end

	def new
		@result = Result.new
	end


	def create
		#need to figure out how to do this asynch, is timing out and loading the page, 
		#thus killing the mysql saves
		@terms_id = Result.eagle_search(results_params) 
	end

	private
	  def results_params
	    params.require(:results).permit(:search_terms)
	  end
end
