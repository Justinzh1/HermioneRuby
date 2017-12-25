require 'fileutils'

module Pipeline
	include BoxAuth
	include YoutubeAuth

	""" find_and_upload_to_yt
			@box_video_id: ID of file to download should be included in request
			@video: corresponding video model
			@course: corresponding course model
	"""
	def find_and_upload_to_yt(box_video_id, video, course)
		box_client = BoxAuth::get_box_client
		abbrev, year = course.abbrev.upcase, course.year.upcase

		file = box_client.file_from_id(box_video_id)
		url = client.download_url(file)
        ext = File.extname(file.name)
        new_folder_path = "#{Rails.root.to_s}/public/#{abbrev}/#{year}/"
        new_file_path = new_folder_path + "#{file.name + ext}"

        byebug
        dirname = File.dirname(new_folder_path)
        unless File.diretory?(dirname)
        	fileutils.mkdir_p(dirname)
        end

        if not File.file?(new_file_path)
            open(new_file_path, 'wb') do |file|
                file << open(url).read
            end
            return 1, "File successfully downloaded!"
        else
        	return 0, "File already exits."
        end
	end
end