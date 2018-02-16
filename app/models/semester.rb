class Semester < ApplicationRecord
	belongs_to :course
	has_many :videos
	has_many :professors
end
