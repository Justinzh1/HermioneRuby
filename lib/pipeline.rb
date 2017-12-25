require 'fileutils'

module Pipeline
	include BoxAuth
	include YoutubeAuth


	""" find_and_upload_to_yt
			@box_video_id: ID of file to download should be included in request
			@video: corresponding video model
			@course: corresponding course model
	"""
	def find_and_upload_to_yt(id, path, course, video)
		box_client = get_box_client
		abbrev, year = course.abbrev.upcase, course.year.upcase

		file = nil
		if !id.empty?
			file = box_client.file_from_id(id)
		elsif !path.empty?
			file = box_client.file_from_path(path)
		end

		# Download file from box	
		url = box_client.download_url(file)
        ext = File.extname(file.name)
        new_folder_path = "#{Rails.root.to_s}/public/#{abbrev}/#{year}/"
        new_file_path = new_folder_path + "#{file.name}"

        # Create rename_path
		ext = File.extname(file.name)
		rename_path = new_folder_path + file.id + ext

        byebug
        # Ensure folder exists for file to be downloaded to
        unless File.directory?(new_folder_path)
        	FileUtils::mkdir_p new_folder_path 
        end

        byebug
        # Check if file eixsts
        if not File.file?(new_file_path)
            open(new_file_path, 'wb') do |file|
                file << open(url).read
            end
            # Rename file
            File.rename(new_file_path, rename_path)
            return 1, "File successfully downloaded!"
        else
        	return 0, "File already exits."
        end
	end
end