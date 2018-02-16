class DriveController < ApplicationController
	include GoogleHelper

	def download
        client = get_box_client 

        file = client.file_from_id(params[:id])
        file_path = get_file_path(file)
        folder_path = get_folder_path(file)

        url = client.download_url(file)

        check_path(folder_path)
        if not File.file?(file_path)
            open(file_path, 'wb') do |file|
                file << open(url).read
            end
            redirect_to box_dashboard_path, :flash => { :success => "File successfully downloaded! "}
        else
            redirect_to box_dashboard_path, :flash => { :warning => "File already exists. "}
        end
    end

    def index
       drive = get_drive
       yt = get_yt
       byebug
    end
end
