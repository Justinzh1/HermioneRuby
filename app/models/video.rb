class Video < ApplicationRecord
	belongs_to :semester

	def get_folder
		return "/#{get_parent_folder}#{self.number}"
	end		

	def get_parent_folder
		return "/#{self.course.abbrev}/#{self.course.year}"
	end

	def get_full_path
		return "/#{get_folder}#{self.path}"
	end	

	def get_local_parent_folder
		return "#{Rails.root.to_s}/public/#{get_parent_folder}"
	end

	def get_local_folder
		return "#{Rails.root.to_s}/public/#{get_folder}"
	end	

	def get_path
		return "#{get_local_folder}/#{self.path}"
	end
end
