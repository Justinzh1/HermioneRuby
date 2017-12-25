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
		video = course.videos.build(video_params)
		byebug
		status, message = Pipeline::find_and_upload_to_yt(params[:box_video_id], course, video)
		if status == 1
			redirect_to process_path, :flash => { :success => message }
		else
			redirect_to process_path, :flash => { :warning => message }
		end
	end
end
