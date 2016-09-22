# Devise User
User.create(
  email:                  'test@example.com',
  password:               'password',
  password_confirmation:  'password'
)

file = File.read(Rails.root.join('db', 'personal_info.json'))
personal_info = JSON.parse(file)

google_drives = {}

# TODO: Clean this up somehow
personal_info['Protocols'].each do |x, protocols|
  next unless x == 'Google Drive'
  protocols.values.each do |data|
    google_drives[data['name']] = ProtocolGoogleDrive.create(
      name:                 data['name'],
      email:                data['email'],
      application_name:     data['application_name'],
      application_version:  data['application_version'],
      client_id:            data['client_id'],
      client_secret:        data['client_secret'],
      scope:                'https://www.googleapis.com/auth/drive',
      credentials_path:     Rails.root.join(
        'credentials', 'google_api_credentials.json'
      ),
      client_secrets_path:  Rails.root.join(
        'credentials', 'google_api_client_secrets.json'
      ),
      api_version:          'v3',
      oob_uri:              'urn:ietf:wg:oauth:2.0:oob',
      folder_id:            data['folder_id']
    )
  end
end
