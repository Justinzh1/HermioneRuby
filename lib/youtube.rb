require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'
Faraday.default_adapter = :httpclient
Faraday::Response.register_middleware :gzip => Faraday::Response::Middleware

module YoutubeAuth

	YOUTUBE_API_SERVICE_NAME = 'youtube'
    YOUTUBE_API_VERSION = 'v3'
    YOUTUBE_UPLOAD_SCOPE = 'https://www.googleapis.com/auth/youtube'
    ENV_VAR = 'GOOGLE_APPLICATION_CREDENTIALS'

	def get_authentication
        client = Google::APIClient.new(
            :application_name => 'Hermione',
            :application_version => '1.0.0'
        )
        youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
        file_storage = Google::APIClient::FileStorage.new("#{ENV['PROGRAM_NAME']}-oauth2.json")
        if file_storage.authorization.nil?
            client_secrets = Google::APIClient::ClientSecrets.load
            flow = Google::APIClient::InstalledAppFlow.new(
              :client_id => client_secrets.client_id,
              :client_secret => client_secrets.client_secret,
              :scope => [YOUTUBE_UPLOAD_SCOPE]
            )
            client.authorization = flow.authorize(file_storage)
        else
            client.authorization = file_storage.authorization
        end

        return youtube, client
    end

    # use videos for testing purposes
    def upload_video(video_params,file_name,upload_folder="videos")
		youtube,client = get_authentication

		file_name = params[:path][:path]
		folder_path = "#{Rails.root.to_s}/public/#{upload_folder}/"
        path = folder_path + file_name

    	body = {
            :snippet => video_params,
            :status => {
                :privacyStatus => 'unlisted'
            } 
        }        
        videos_insert_response = client.execute!(
          :api_method => youtube.videos.insert,
          :body_object => body,
          :media => Google::APIClient::UploadIO.new(path, 'video/*'),
          :parameters => {
            :uploadType => 'resumable',
            :part => body.keys.join(',')
          }
        )

        videos_insert_response.resumable_upload.send_all(client)
    end
end
