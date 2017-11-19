class Course < ApplicationRecord
	has_many :videos
	has_many :professors
end
