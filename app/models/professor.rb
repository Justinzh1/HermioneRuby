class Professor < User 
	has_and_belongs_to_many :courses, required: true
end
