# Class to model transfer to Google Drive
class ProtocolGoogleDrive < Protocol
  require 'google/apis/drive_v3'
  require 'googleauth'
  require 'googleauth/stores/file_token_store'

  # Establist Connection
  def connect
    @service = Google::Apis::DriveV3::DriveService.new
    @service.request_options.timeout_sec = (60 * 60)
    @service.request_options.open_timeout_sec = (60 * 60)
    @service.request_options.retries = 3
    @service.client_options.application_name = application_name
    @service.authorization = authorize
    @service
  end

  # Authorize the connection
  def authorize
    FileUtils.mkdir_p(File.dirname(credentials_path))

    client_id = Google::Auth::ClientId.from_file(client_secrets_path)
    fts = Google::Auth::Stores::FileTokenStore.new(file: credentials_path)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, fts)
    credentials = authorizer.get_credentials(email)

    credentials.nil? ? create_credentials(authorizer) : credentials
  end

  def create_credentials(authorizer)
    url = authorizer.get_authorization_url(base_url: oob_uri)
    puts "Open the following URL in the browser and enter the \
          resulting code after authorization"
    puts url
    code = STDIN.gets.chomp
    authorizer.get_and_store_credentials_from_code(
      user_id: email, code: code, base_url: oob_uri
    )
  end

  # TODO: Some kind of list / integrity checking

  def find(name)
    connect
    response = @service.list_files(
      q: "name='#{name}'", fields: 'nextPageToken, files(id, name, md5Checksum)'
    )
    response.files.each do |file|
      puts "#{file.name} => (#{file.id}) / (#{file.md5_checksum})"
    end
  end

  def send(filepath, remote_name, po) # protocol_object is folder
    connect unless @service

    file_metadata = { name: remote_name, parents: [] }

    file_metadata[:parents] << po.google_ref if po.google_ref

    file = @service.create_file(file_metadata,
                                fields: 'id',
                                upload_source: File.expand_path(filepath),
                                content_type: 'application/octet-stream')
    create_protocol_object(remote_name, id, file, po)
  end

  def validate_protocol_object(protocol_object, local_file)
    connect
    file = @service.get_file(
      protocol_object.google_ref, fields: 'id, name, md5Checksum'
    )
    (file.md5_checksum == local_file.md5_checksum)
  end

  def create_protocol_object(remote_name, id, file, po)
    pgdf = ProtocolGoogleDriveFile.create(
      name: remote_name, protocol_id: id, google_ref: file.id
    )
    ProtocolGoogleDriveObjectHierarchy.create(
      parent_id: po.id, child_id: pgdf.id
    )
    pgdf
  end

  def delete(protocol_object)
    connect unless @service
    @service.delete_file protocol_object.google_ref
  end

  # Google Drive does not enforce unique paths
  #   so need to keep a record of which folders are used by this app.
  # Also, enforce unique paths on the records within this app
  #   so that even if duplicates exist on Drive, the correct folders are used
  # TODO: See if some of this can be abstracted out to ProtocolObject
  def create_folders_from(path)
    segments = path.split('/')
    parent, folder = nil
    segments.each do |segment|
      next if segment == ''
      # Check if the segment exists locally
      folders = ProtocolGoogleDriveFolder.where(name: segment, protocol_id: id)

      # If there is no matching folder then create one
      create_folder(segment, folder, parent) if folders.empty?

      folder = match_folder(folders, segment, parent)

      parent = folder
    end
    folder
  end

  def create_folder(segment, folder, parent)
    folder = ProtocolGoogleDriveFolder.create(name: segment, protocol_id: id)
    ProtocolGoogleDriveObjectHierarchy.create(
      parent_id: parent.id, child_id: folder.id
    ) if parent
  end

  def match_folder(folders, segment, parent)
    # If there are matches then see if there is one with the correct parent
    folders.each do |f|
      # It is a root folder
      next unless f.name == segment
      return f if parent.nil?

      unless f.parent.nil?
        return f if parent.id == f.parent.id
      end
    end
  end
end
