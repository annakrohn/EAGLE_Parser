class ResultsController < ApplicationController
	#controlling searches and displaying results
	def index
		
	end

	def new
		@result = Result.new
	end


	def create
		debugger
		@result = Result.eagle_search(results_params) 

	end

	private
	  def results_params
	    params.require(:results).permit(:search_terms)
	  end
end
