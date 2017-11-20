require 'google/apis/youtube_v3'
require 'googleauth'
require 'googleauth/web_user_authorizer'
require "google/apis/storage_v1"
    
class YoutubeController < ApplicationController
    YT = Google::Apis::YoutubeV3

    YOUTUBE_API_SERVICE_NAME = 'youtube'
    YOUTUBE_API_VERSION = 'v3'
    ENV_VAR = 'GOOGLE_APPLICATION_CREDENTIALS'

    def get_authorization(path, scope)
        raise "file #{path} does not exist" unless File.exist?(path)
        byebug
        File.open(path) do |f|
            return Google::Auth::CredentialsLoader.make_creds(json_key_io: f, scope: scope)
        end
    end

    def get_service
        client = Google::APIClient.new(
            :key => ENV['YOUTUBE_DEVELOPER_KEY'],
            :authorization => nil,
            :application_name => "Hermione", 
            :application_version => '1.0.0'
            )
        youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
        return client, youtube
    end

    def index
        youtube = Google::Apis::YoutubeV3::YouTubeService.new
        scopes =  [
            "https://www.googleapis.com/auth/youtube", 
            "https://www.googleapis.com/auth/youtube.force-ssl", 
            "https://www.googleapis.com/auth/youtube.upload"
        ]
        # authorization = Google::Auth.get_application_default(scopes)
        # TODO issue with creating authorization
        # authorization = get_authorization("#{Rails.root}/config/client_secrets.json", scopes)
    end

    def auth

    end

    def upload

    end
end
