class Term < ActiveRecord::Base
	has_many :results
	#for keeping track of the search terms already entered
end
