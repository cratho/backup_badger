# Class to model a Folder/Collection on Google Drive
class ProtocolGoogleDriveFolder < ProtocolGoogleDriveObject
  # Hooks
  def before_validation
    create_drive_folder(name)
    super
  end

  # Other functions
  def create_drive_folder(name)
    service = protocol.connect

    file_metadata = {
      name: name,
      mime_type: 'application/vnd.google-apps.folder'
    }

    file = service.create_file(file_metadata, fields: 'id')
    # TODO: Error handling
    self.google_ref = file.id
  end
end
