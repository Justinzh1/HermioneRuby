require 'rest-client'
require 'boxr'
require 'open-uri'

module BoxAuth

    # Uploads video and renames it 
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


    def get_box_client
        expireTime = session[:expiration]
        client = nil
        # Existing client is valid
        if !expireTime.nil? and Time.now < expireTime
            client = $box_client
        end

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

        if !new_client.nil?
            $box_client = new_client
            @client = $box_client
        end
        session[:expiration] = Time.now + expire.to_i 
        return @client
    end

end 