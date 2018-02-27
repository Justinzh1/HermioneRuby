require 'googleauth'
require 'google/apis/drive_v3'
require 'google/apis/youtube_v3'

DRIVE_SCOPE = 'https://www.googleapis.com/auth/drive'
YT_SCOPE = 'https://www.googleapis.com/auth/youtube'
FILE_TYPE = 'txt'

module GoogleHelper

    def get_drive
      if !defined? @@drive
        auth = authorize(DRIVE_SCOPE)
        drive = Google::Apis::DriveV3::DriveService.new
        drive.client_options.application_name = "Hermione"
        drive.authorization = auth
        @@drive = drive
      end
      return @@drive
    end

    def get_yt
      auth = authorize(YT_SCOPE)
      yt = Google::Apis::YoutubeV3::YouTubeService.new
      yt.client_options.application_name = "Hermione"
      yt.authorization = auth
      return yt
    end

    def upload_to_drive(semester, video=nil, local_path=nil)
      drive = get_drive
      video_num = if !video.nil? then video.number else nil end
      path = [semester.course.abbrev.upcase,semester.year.upcase,video_num].compact
        # create_video(path, drive, semester, video)
        # Generate folders and TODO check for errors
      create_folder(path, drive, semester, video, nil, local_path)
    end

    def create_video(path, ext, drive, semester, video, local_path=nil)
      folder = drive.get_file(semester.folder_id)
      file_metadata = { name: path, fields: 'id', parents: [{id:folder.id}], upload_source: '#{Rails.root.to_s}/#{local_path}', content_type: FILE_TYPE}
      file = drive.create_file(file_metadata, fields: 'id')
    end

    def create_folder(path, drive, semester, video, parent=nil, local_path=nil)
      # file_metadata = {name: name, mime_type: "application/vnd.google-apps.folder"}
      # file = drive.create_file(file_metadata, fields: 'id')
      if path.empty?
        return 
      end

      if semester.folder_id and video and local_path
        ext = File.extname(local_path)
        create_video(path[-1], ext, drive, semester, video, local_path)
        return
      end

      filename = path[0]
      ext = File.extname(filename)

      if parent.nil? and ext.empty?
        file_metadata = { name: filename, mime_type: "application/vnd.google-apps.folder"}
        file = drive.create_file(file_metadata, fields: 'id')
        semester.folder_id = file.id
        semester.save!
      elsif ext.empty?
        file_metadata = { name: filename, parents: [{id:parent.id}], mime_type: "application/vnd.google-apps.folder"}
        file = drive.create_file(file_metadata, fields: 'id')
      else
        create_video(path, ext, drive, semester, video, local_path)
      end
      path.slice!(0)
      create_folder(path, drive, semester, video, file, local_path)
    end

    def authorize(scope)
      authorization = Google::Auth.get_application_default(scope)
    end

    def get_class_folder(abbrev, year, folder_id=nil)

      if !folder_id.nil?
        # Download folder
        folder = @@drive.get_file(folder_id)
      else
        # Should never be needed in full app

      end
    end

end 