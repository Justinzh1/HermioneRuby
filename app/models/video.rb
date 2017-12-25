class Video < ApplicationRecord
	belongs_to :course
	include YoutubeAuth
end
