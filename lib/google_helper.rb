require 'googleauth'
require 'google/apis/drive_v3'
require 'google/apis/youtube_v3'

DRIVE_SCOPE = 'https://www.googleapis.com/auth/drive'
YT_SCOPE = 'https://www.googleapis.com/auth/youtube'

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

    def upload_to_drive(course, lecture=nil)
      # Generate folders
      drive = get_drive
      lecture_num = if !lecture.nil? then lecture.number else nil end

      # Check for errors
      create_folder([course.abbrev.upcase,course.year.upcase,lecture_num].compact, drive, course, lecture)
    end

    def create_folder(path, drive, course, lecture, parent=nil)
      # file_metadata = {name: name, mime_type: "application/vnd.google-apps.folder"}
      # file = drive.create_file(file_metadata, fields: 'id')
      if path.empty?
        return 
      end

      filename = path[0]
      ext = File.extname(filename)

      if parent.nil? and ext.empty?
        file_metadata = { name: filename, mime_type: "application/vnd.google-apps.folder"}
        file = drive.create_file(file_metadata, fields: 'id')
        course.folder_id = file.id
        course.save!
        path.slice!(0)
        create_folder(path, drive, course, lecture, file)
      elsif ext.empty?
        byebug
        file_metadata = { name: filename, parents: [{id:parent.id}], mime_type: "application/vnd.google-apps.folder"}
        file = drive.create_file(file_metadata, fields: 'id')
        path.slice!(0)
        create_folder(path, drive, course, lecture, file)
      end

    end

    def authorize(scope)
      # scopes =  [ 'https://www.googleapis.com/auth/drive',
                  # 'https://www.googleapis.com/auth/youtube']
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