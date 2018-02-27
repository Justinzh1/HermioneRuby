
module YoutubeHelper
	includes GoogleHelper

	def upload_to_yt(video_params, video)
		yt = get_yt
		folder = video.get_local_folder

		byebug
		download(video)

		body = {
			:snippet => video_params,
			:status => {
				:privacyStatus => 'unlisted'
			}
		}

		yt.insert_video('snippet', body, upload_source: video.get_path, content_type: 'video/*')
	end
	
end
