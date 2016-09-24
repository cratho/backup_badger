Sequel.migration do
  change do
    create_table(:compression_tar_bzips) do
      primary_key :id
    end
    
    create_table(:compressions) do
      primary_key :id
      column :content_type, "varchar(255)", :null=>false
      column :name, "varchar(255)", :null=>false
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
    end
    
    create_table(:encapsulations) do
      primary_key :id
      column :content_type, "varchar(255)", :null=>false
      column :name, "varchar(255)", :null=>false
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
    end
    
    create_table(:encryption_gpgs) do
      primary_key :id
    end
    
    create_table(:encryptions) do
      primary_key :id
      column :content_type, "varchar(255)", :null=>false
      column :name, "varchar(255)", :null=>false
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
    end
    
    create_table(:protocols) do
      primary_key :id
      column :content_type, "varchar(255)", :null=>false
      column :name, "varchar(255)"
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
    end
    
    create_table(:rotations) do
      primary_key :id
      column :content_type, "varchar(255)", :null=>false
      column :name, "varchar(255)", :null=>false
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
    end
    
    create_table(:schema_migrations) do
      column :filename, "varchar(255)", :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:targets) do
      primary_key :id
      column :content_type, "varchar(255)", :null=>false
      column :name, "varchar(255)", :null=>false
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
    end
    
    create_table(:users) do
      primary_key :id
      column :email, "varchar(255)", :default=>"", :null=>false
      column :encrypted_password, "varchar(255)", :default=>"", :null=>false
      column :reset_password_token, "varchar(255)"
      column :reset_password_sent_at, "varchar(255)"
      column :remember_created_at, "timestamp"
      column :sign_in_count, "integer", :default=>0, :null=>false
      column :current_sign_in_at, "timestamp"
      column :last_sign_in_at, "timestamp"
      column :current_sign_in_ip, "varchar(255)"
      column :last_sign_in_ip, "varchar(255)"
      column :created_at, "timestamp"
      column :updated_at, "timestamp"
      
      index [:email], :unique=>true
      index [:reset_password_token], :unique=>true
    end
    
    create_table(:backups) do
      primary_key :id
      foreign_key :user_id, :users, :null=>false
      column :name, "varchar(255)", :null=>false
      column :tmp_path, "varchar(255)", :default=>"/tmp", :null=>false
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
    end
    
    create_table(:compressions_encapsulations) do
      primary_key :id
      foreign_key :encapsulation_id, :encapsulations, :null=>false
      foreign_key :compression_id, :compressions, :null=>false
    end
    
    create_table(:encapsulations_encryptions) do
      primary_key :id
      foreign_key :encapsulation_id, :encapsulations, :null=>false
      foreign_key :encryption_id, :encryptions, :null=>false
    end
    
    create_table(:protocol_google_drives) do
      foreign_key :id, :protocols, :null=>false
      column :email, "varchar(255)", :null=>false
      column :application_name, "varchar(255)", :null=>false
      column :application_version, "varchar(255)", :null=>false
      column :client_id, "varchar(255)", :null=>false
      column :client_secret, "varchar(255)", :null=>false
      column :scope, "varchar(255)", :null=>false
      column :credentials_path, "varchar(255)", :null=>false
      column :client_secrets_path, "varchar(255)", :null=>false
      column :oob_uri, "varchar(255)", :null=>false
      column :api_version, "varchar(255)", :null=>false
      column :folder_id, "varchar(255)", :default=>Sequel::LiteralString.new("0"), :null=>false
    end
    
    create_table(:protocol_objects) do
      primary_key :id
      column :content_type, "varchar(255)", :null=>false
      foreign_key :protocol_id, :protocols, :null=>false
      column :name, "varchar(255)", :null=>false
      column :deleted, "Boolean", :default=>false, :null=>false
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
    end
    
    create_table(:target_globs) do
      primary_key :id
      foreign_key :target_id, :targets, :null=>false
      column :line, "varchar(255)", :null=>false
      column :exclude, "Boolean", :default=>false, :null=>false
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
    end
    
    create_table(:backup_rotations) do
      primary_key :id
      foreign_key :backup_id, :backups, :null=>false
      foreign_key :rotation_id, :rotations, :null=>false
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
    end
    
    create_table(:backups_encapsulations) do
      primary_key :id
      foreign_key :encapsulation_id, :encapsulations, :null=>false
      foreign_key :backup_id, :backups, :null=>false
    end
    
    create_table(:backups_targets) do
      primary_key :id
      foreign_key :backup_id, :backups, :null=>false
      foreign_key :target_id, :targets, :null=>false
    end
    
    create_table(:local_files) do
      primary_key :id
      foreign_key :backup_id, :backups, :null=>false
      column :name, "varchar(255)", :null=>false
      column :extension, "varchar(255)", :null=>false
      column :path, "varchar(255)", :null=>false
      column :deleted, "Boolean", :default=>false, :null=>false
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
    end
    
    create_table(:protocol_google_drive_objects) do
      foreign_key :id, :protocol_objects, :null=>false
      column :google_ref, "varchar(255)", :null=>false
    end
    
    create_table(:protocol_object_hierarchies) do
      primary_key :id
      foreign_key :parent_id, :protocol_objects
      foreign_key :child_id, :protocol_objects
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
    end
    
    create_table(:backup_rotations_protocol_objects) do
      primary_key :id
      foreign_key :backup_rotation_id, :backup_rotations, :null=>false
      foreign_key :protocol_object_id, :protocol_objects, :null=>false
    end
    
    create_table(:transactions) do
      primary_key :id
      column :content_type, "varchar(255)", :null=>false
      foreign_key :backup_rotation_id, :backup_rotations, :null=>false
      foreign_key :protocol_object_id, :protocol_objects, :null=>false
      column :scheduled_date, "date", :null=>false
      column :scheduled_time, "timestamp", :null=>false
      column :completed, "Boolean", :default=>false, :null=>false
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
    end
    
    create_table(:local_files_transactions) do
      primary_key :id
      foreign_key :local_file_id, :local_files, :null=>false
      foreign_key :transaction_id, :transactions, :null=>false
    end
    
    create_table(:protocol_objects_transaction_uploads) do
      primary_key :id
      foreign_key :transaction_upload_id, :transactions, :null=>false
      foreign_key :protocol_object_id, :protocol_objects, :null=>false
    end
    
    create_table(:transaction_deletions) do
      foreign_key :id, :transactions, :null=>false
      foreign_key :transaction_upload_id, :transactions, :null=>false
    end
    
    create_table(:transaction_logs) do
      primary_key :id
      foreign_key :transaction_id, :transactions, :null=>false
      column :successful, "Boolean", :default=>false, :null=>false
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
    end
    
    create_table(:transaction_uploads) do
      foreign_key :id, :transactions, :null=>false
      column :remote_filename, "varchar(255)", :null=>false
    end
    
    create_table(:transaction_log_messages) do
      primary_key :id
      foreign_key :transaction_log_id, :transaction_logs, :null=>false
      column :message, "Text"
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
    end
  end
end
              Sequel.migration do
                change do
                  self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160509202535_devise_create_users.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160724150139_create_backups.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160724150446_create_targets.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160724150711_create_encapsulations.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160724150800_create_encryptions.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160724150806_create_compressions.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160724150923_create_rotations.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160724151415_create_encapsulations_compressions.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160724151421_create_encapsulations_encryptions.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160724152451_create_backups_encapsulations.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160724152723_create_backup_rotations.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160724152900_create_local_files.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160724153413_create_local_files_transactions.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160724153534_create_protocols.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160724154040_create_backup_rotations_protocol_objects.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160724155326_create_backups_targets.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160725100347_create_protocol_google_drives.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160814160143_create_protocol_objects.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160814160144_create_protocol_object_hierarchies.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160814162040_create_protocol_google_drive_objects.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160911125002_create_transactions.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160911125955_create_transaction_uploads.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160912133531_create_transaction_deletions.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160912141849_create_protocol_objects_transaction_uploads.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160917143553_create_target_globs.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160920111431_create_encryption_gpgs.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160920111503_create_compression_tar_bzips.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160924171223_create_transaction_logs.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160924171410_create_transaction_log_messages.rb')"
                end
              end
