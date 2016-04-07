class MainController < ApplicationController
  def index
  	@terms = Term.all
  end
  
end
