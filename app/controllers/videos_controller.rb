class VideosController < ApplicationController	
	include Pipeline

	def video_params 
		params.require(:video).permit(:title, :description, :category_id, :tags, :category_id)
	end

	def course_params
		params.require(:course).permit(:year, :code)
	end

	def index

	end

	# Assumes video already exists on box
	def upload
		course = Course.find_by :year => course_params[:year], :code => course_params[:code]
		box_video_id ||= params[:video][:box_video_id]
		box_video_path ||= params[:video][:box_video_path]
		# fix this
		video_params[:tags] = video_params[:tags].split(',').map { |tag| 
			tag.downcase
		}
		video = course.videos.build(video_params)
		status, message = find_and_upload_to_yt(box_video_id, box_video_path, course, video, video_params)
		if status == 1
			redirect_to process_path, :flash => { :success => message }
		else
			redirect_to process_path, :flash => { :warning => message }
		end
	end
end
