require 'google/api_client'

class YoutubeController < ApplicationController

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
        return youtube
    end

    def index

    end

    # Privacy status = ['public', 'private', 'unlisted']
    def upload
        youtube = auth
        # force to unlisted
        begin 
            body = {
                :snippet => params[:video],
                :status => {
                    :privacyStatus => 'unlisted'
                } 
            }        

            videos_insert_response = client.execute!(
              :api_method => youtube.videos.insert,
              :body_object => body,
              :media => Google::APIClient::UploadIO.new(params[:file], 'video/*'),
              :parameters => {
                :uploadType => 'resumable',
                :part => body.keys.join(',')
              }
            )
            
            videos_insert_response.resumable_upload.send_all(client)

            puts "Video id '#{videos_insert_response.data.id}' was successfully uploaded."
        rescue Google::APIClient::TransmissionError => e
            puts e.result.body
        end
    end
end
