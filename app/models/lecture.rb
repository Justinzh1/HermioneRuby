import 'date'

class Lecture < ApplicationRecord
	has_many :videos
	belongs_to :semester
	
	# is this correct object	
	attr_default :date, Date.today  
end
