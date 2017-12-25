require 'rest-client'
require 'boxr'
require 'open-uri'

module BoxAuth

    """ TODO: Upgrade to Chunked Uploads when Ruby is supported
        https://developer.box.com/v2.0/reference#chunked-upload

        TODO: Batched jobs when uploading multiple videos?
        - Potential solution is to use rocketjob
        - http://rocketjob.io/guide.html

        TODO: Scaling and dealing with concurrent Uploads
        - Puma
        - Phusion Passenger 5
          * May already be included in heroku?
          * https://www.speedshop.co/2015/07/29/scaling-ruby-apps-to-1000-rpm.html
    """

    """
        upload_video_box
            @upload_file_path: local path of file
            @folder: folder obj to upload into on box
            @upload_folder: folder which file is located in: assets/public/___
    """
	def upload_video_box(upload_file_path, folder, upload_folder="videos")
        # Upload file
        client = get_box_client
		status = client.upload_file(upload_file_path, folder)

        byebug 
        # Rename file 
        file = File.read(upload_file_path)
        file_ext = File.extname(status.name)
        folder_path = "#{Rails.root.to_s}/public/#{upload_folder}/"
        new_name = status.id + file_ext
        new_file_path = folder_path + new_name 
        File.rename(upload_file_path, new_file_path)

        # Optionally return status 
        return status
	end

    def download_video_box_by_id(box_video_id)
        file = client.file_from_id(box_video_id)
        return download_file(file)         
    end

    def download_video_box_by_path(file_path)
        file = client.file_from_path(file_path)
        return download_file(file)
    end

    def download_file(file)
        url = client.download_url(file)
        ext = File.extname(file.name)
        new_folder_path = "#{Rails.root.to_s}/public/#{abbrev}/#{year}/"
        new_file_path = new_folder_path + "#{file.name + ext}"

        dirname = File.dirname(new_folder_path)
        unless File.diretory?(dirname)
            fileutils.mkdir_p(dirname)
        end

        if not File.file?(new_file_path)
            open(new_file_path, 'wb') do |file|
                file << open(url).read
            end
            return file, "File successfully downloaded!"
        else
            return nil, "File already exits."
        end
    end

    def find_box_video(file_path, id)
        if file_path
            find_by_path(file_path)
        elsif id
            find_by_id(id)
        else
            return nil
        end
    end

    def find_by_path(file_path)
        client = get_box_client
        file = client.find_from_path(file_path)
    end 

    def find_by_id(id)
        client = get_box_client
        file = client.find_from_id(id)
    end

    def get_box_client
        expireTime = session[:expiration]
        client = nil

        # Existing client is valid
        if !expireTime.nil? and Time.now < expireTime and $box_client
            client = $box_client
            return client
        end

        # Fetch client 
        if !@code.nil?
            client = get_token 
        end

        return client
    end

    def get_token 
        body = "grant_type=authorization_code&code=" + @code + "&client_id=" + ENV['BOX_CLIENT_ID'] + "&client_secret=" + ENV['BOX_CLIENT_SECRET'] + "&redirect_uri=http://localhost:3000/box" 
        res = HTTP.headers("Content-Type":"application/x-www-form-urlencoded").post('https://api.box.com/oauth2/token', :body => body)
        response = JSON.parse(res.to_s)
        refresh_token = response['refresh_token']
        access_token = response['access_token']
        expire = response['expires_in']

        if refresh_token.nil? or access_token.nil? or expire.nil?
            render :index
            return
        end
        token_refresh_callback = lambda {|access, refresh, identifier| save_box_token(access, refresh)}
        new_client = Boxr::Client.new(access_token,
                      refresh_token: refresh_token,
                      client_id: ENV['BOX_CLIENT_ID'],
                      client_secret: ENV['BOX_CLIENT_SECRET'],
                      &token_refresh_callback)

        # byebug
        if !new_client.nil?
            $box_client = new_client
            @client = $box_client
        end
        session[:expiration] = Time.now + expire.to_i 
        return @client
    end

end 