class CoursesController < ApplicationController
	include GoogleHelper

	def course_params
        params.require(:course).permit(:title, :code, :year, :abbrev, :description)
    end

    def course_semester_params
    	params.require(:semester).permit(:year)
    end

	def new
	end

	def edit

	end

	def show
		@courses = Course.all
	end

	def update

	end

	def destroy

	end

	def index
		@courses = Course.all
	end

	# create new course
	def create
		found = Course.find_by_title_and_year(params[:course][:title], params[:course][:year])

		# Handle redirects and flashing
		if found.nil?
			c = Course.create!(course_params)
			byebug
			upload_to_drive(c)
		end
		redirect_to root_path
	end

	def new_semester
		@course = Course.find(params[:id])
		render :new_semester
	end
	
end
