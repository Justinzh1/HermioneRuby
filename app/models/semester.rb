class Semester < ApplicationRecord
	belongs_to :course
	has_many :lectures
	has_many :professors
end
