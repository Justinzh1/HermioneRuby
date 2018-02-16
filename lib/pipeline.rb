require 'fileutils'

module Pipeline
	include YoutubeAuth

	""" find_and_upload_to_yt
			@box_video_id: ID of file to download should be included in request
			@video: corresponding video model
			@course: corresponding course model
	"""
	def find_and_upload_to_yt(id, path, course, video, video_params)
		# Downloads and renames file	
		begin
			video = download_from_box(id, path, course, video)
		rescue ArgumentError
			return 0, "File already exists."
		end

		# Strip params
		video_params.slice(:title, :description, :tags, :category_id)

		# begin
		upload_video_youtube(video_params, video.get_local_path, video.get_folder)
		return 1, "Video successfully uploaded!"
		# rescue => error
			# return 0, "Upload failed. \n #{error.to_s[0..100]}"
		# end
	end

	def download_from_box(id, path, course, video)
		box_client = get_box_client
		abbrev, year = course.abbrev.upcase, course.year.upcase

		file = nil
		if !id.empty?
			file = box_client.file_from_id(id)
		elsif !path.empty?
			file = box_client.file_from_path(path)
		end

        ext = File.extname(file.name)
        new_folder_path = "#{Rails.root.to_s}/public#{video.get_folder}"
        new_file_path = new_folder_path + "#{file.name}"

        # Create rename_path
		ext = File.extname(file.name)
		new_file_name = file.id + ext
		rename_path = new_folder_path + new_file_name

        # Ensure folder exists for file to be downloaded to
        unless File.directory?(new_folder_path)
        	FileUtils::mkdir_p new_folder_path 
        end

        # Check if file eixsts
        if not File.file?(new_file_path)
    		# Download file from box	
			url = box_client.download_url(file)
            open(new_file_path, 'wb') do |f|
                f << open(url).read
            end
        end

        # Rename file
        File.rename(new_file_path, rename_path)

        # Save video model
        video.box_id = file.id
        video.path = file.name
        video.save!

        return video
	end


	def upload_to_yt(id, path, course, video)

	end
end