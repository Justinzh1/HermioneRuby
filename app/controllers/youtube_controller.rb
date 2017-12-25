class YoutubeController < ApplicationController
    include YoutubeAuth

    def video_params
        params.require(:video).permit(:title, :desc, :tags, :category_id)
    end

    def path_params
        params.require(:path).permit(:path)
    end

    def index
    end

    # Privacy status = ['public', 'private', 'unlisted']
    def upload
        file_name = path_params[:path]
        begin 
            upload_video(video_params,file_name) 
            puts "Video id '#{videos_insert_response.data.id}' was successfully uploaded."
            redirect_to youtube_path, :flash => { :success => "Video successfully uploaded! "}
        rescue Google::APIClient::TransmissionError => e
            puts e.result.body
            redirect_to youtube_path, :flash => { :error => "Failed to upload video. "}
        end
    end
end
