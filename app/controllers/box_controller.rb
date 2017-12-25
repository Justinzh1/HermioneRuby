require 'rest-client'
require 'boxr'
require 'open-uri'

class BoxController < ApplicationController
    include BoxAuth
    before_action :require_client, only: [:get_box_client]

    # BUG: Navigating to box/dashboard before authentication
    def require_client
        unless $client
            redirect_to box_auth_path
        end
    end

    def save_box_token(access, refresh)
        BoxToken.create(:token => refresh)
    end

    def upload
        placeholder = "videos" # temporary
        url = params[:url][:path]
        folder_id = params[:url][:folder_id]
        client = get_box_client 

        folder = client.folder_from_id(folder_id)
        if not folder
            redirect_to box_dashboard_path, :flash => { :warning => "Invalid folder."}
            return
        end
        upload_file_path = "#{Rails.root.to_s}/public/#{placeholder}/#{url}"
        byebug
        if File.file?(upload_file_path)
            status = nil
            begin 
                status = upload_video_box(upload_file_path, folder)
            rescue Boxr::BoxrError
                redirect_to box_dashboard_path, :flash => { :error => "Upload failed."}
                return
            end
            byebug
            redirect_to box_dashboard_path, :flash => { :success => "Successfully uploaded file!"}
            return
        else
            redirect_to box_dashboard_path, :flash => { :warning => "Invalid file."}
            return
        end
    end

    def download
        folder = "videos" # temporary 

        client = get_box_client 
        file = client.file_from_id(params[:id])
        url = client.download_url(file)
        ext = File.extname(file.name)
        new_file_path = "#{Rails.root.to_s}/public/#{folder}/#{params[:id]}#{ext}"
        if not File.file?(new_file_path)
            open(new_file_path, 'wb') do |file|
                file << open(url).read
            end
            redirect_to box_dashboard_path, :flash => { :success => "File successfully downloaded! "}
        else
            redirect_to box_dashboard_path, :flash => { :warning => "File already exists. "}
        end
    end

    def dashboard
        client = get_box_client 
        @client_id = client.client_id
        @folders = client.root_folder_items
        @folder_items = {}
        @folders.each do |folder| 
            @folder_items[folder.id] = client.folder_items(folder)
        end
    end

    def index
        @code = params[:code]
        @state = params[:state]
        @client = get_box_client
        if @client
            redirect_to box_dashboard_path
        end
    end

    def auth 
        res = HTTP.follow.get('https://account.box.com/api/oauth2/authorize', :params => {
                response_type: 'code',
                client_id: ENV['BOX_CLIENT_ID'],
                redirect_uri: "http://localhost:3000/box",
                state: 'pineapple'
            })
        redirect_to res.uri.to_s
    end
end
