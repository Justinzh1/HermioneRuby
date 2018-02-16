class SemestersController < ApplicationController
	def new
		byebug
		@course_id = params[:id]
	end

	def update
		course = Course.find(params[:course][:id])
		if !course.nil?
			byebug
			year = params[:semester][:year]
			semester = if !course.semesters.empty? then course.semesters.find(:year => year) else nil end
			if semester.nil?
				semester = course.semesters.new(:year => year)
				semester.save!
				flash[:success] = "Semester successfully added!"
				redirect_to courses_all_path
			end
		end
	end

	def show
		@semester = Semester.find(params[:id])
		@course = @semester.course
	end

end
