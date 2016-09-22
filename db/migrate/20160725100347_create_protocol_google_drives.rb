Sequel.migration do
  change do
    create_table :protocol_google_drives do
      # Keys & Structure
      foreign_key :id, :protocols,  null: false

      # Attributes
      String :email,                null: false
      String :application_name,     null: false
      String :application_version,  null: false
      String :client_id,            null: false
      String :client_secret,        null: false
      String :scope,                null: false
      String :credentials_path,     null: false
      String :client_secrets_path,  null: false
      String :oob_uri,              null: false
      String :api_version,          null: false
      String :folder_id,            null: false, default: 0
    end
  end
end
