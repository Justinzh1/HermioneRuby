class Video < ApplicationRecord
	belongs_to :course
	include YoutubeAuth

	def get_folder
		return "/#{self.course.abbrev}/#{self.course.year}/"
	end		

	def get_full_path
		return "#{get_folder}#{self.path}"
	end	

	def get_local_path
		ext = File.extname(self.path)
		return "#{self.box_id}#{ext}"
	end	
end
