require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'
Faraday.default_adapter = :httpclient
Faraday::Response.register_middleware :gzip => Faraday::Response::Middleware
# 259103669023.mp4

class YoutubeController < ApplicationController

    def video_params
        params.require(:video).permit(:title, :desc, :tags, :category_id)
    end

    def path_params
        params.require(:path).permit(:path)
    end

    YOUTUBE_API_SERVICE_NAME = 'youtube'
    YOUTUBE_API_VERSION = 'v3'
    YOUTUBE_UPLOAD_SCOPE = 'https://www.googleapis.com/auth/youtube'
    ENV_VAR = 'GOOGLE_APPLICATION_CREDENTIALS'


    def auth
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

    def index
    end

    # Privacy status = ['public', 'private', 'unlisted']
    def upload
        youtube,client = auth
        # force to unlisted
        folder = "videos"
        file_name = params[:path][:path]
        path = "#{Rails.root.to_s}/public/#{folder}/#{file_name}"
        begin 
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

            puts "Video id '#{videos_insert_response.data.id}' was successfully uploaded."
            redirect_to youtube_path, :flash => { :success => "Video successfully uploaded! "}
        rescue Google::APIClient::TransmissionError => e
            puts e.result.body
            redirect_to youtube_path, :flash => { :error => "Failed to upload video. "}
        end
    end
end
