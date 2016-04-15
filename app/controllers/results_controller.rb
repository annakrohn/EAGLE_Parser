class ResultsController < ApplicationController
	#controlling searches and displaying results
	def index
		@term_id = params[:term_id]
		@results = Result.where(queryTerms: @term_id)
		@count = Result.where(queryTerms: @term_id).count
		return @count, @term_id
	end

	def new
		@result = Result.new
	end


	def create
		@terms_id = Result.eagle_search(results_params) 
	end

	def analysis
		@analysis, @item_sort, @tags = Result.analysis(results_params)
	end

	private
	  def results_params
	    params.permit(:search_terms, :id, :utf8, :authenticity_token, :commit, results: [:search_terms] )
	  end
end
