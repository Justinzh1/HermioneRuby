class VideosController < ApplicationController	
	include GoogleHelper

	def video_params 
		params.require(:video).permit(:title, :description, :category_id, :tags, :category_id, :number)
	end

	def course_params
		params.require(:course).permit(:year, :code)
	end

	def drive_params
		params.require(:drive).permit(:file_path)
	end

	# Assumes video already exists on box
	# def upload
	# 	course = Course.find_by :year => course_params[:year], :code => course_params[:code]
	# 	box_video_id ||= params[:video][:box_video_id]
	# 	box_video_path ||= params[:video][:box_video_path]
	# 	# fix this
	# 	video_params[:tags] = video_params[:tags].split(',').map { |tag| 
	# 		tag.downcase
	# 	}
	# 	video = course.videos.build(video_params)
	# 	status, message = find_and_upload_to_yt(box_video_id, box_video_path, course, video, video_params)
	# 	if status == 1
	# 		redirect_to process_path, :flash => { :success => message }
	# 	else
	# 		redirect_to process_path, :flash => { :warning => message }
	# 	end
	# end

	def new
		@semester = Semester.find(params[:semester_id])
		@course = Course.find(@semester.course.id)
	end

	def create
		semester = Semester.find(params[:semester_id])
		video = semester.videos.new(video_params)
		upload_to_drive(semester, video, drive_params[:file_path])
		redirect_to new_courses_semester_video(semester.id), :flash => { :success => "File successfully uploaded! "}
	end
end
