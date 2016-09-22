# An Encapsulation combines compression and encryption
class Encapsulation < Sequel::Model
  plugin :class_table_inheritance, key: :content_type
  plugin :timestamps
  one_through_one :backup
  one_through_one :encryption
  one_through_one :compression

  def create_local_file
    compressed_file_path = compression.create_temp_file backup

    encrypted_file_path = encryption.create_temp_file compressed_file_path

    perm_path = "#{compressed_file_path}.#{extension}"

    # TODO: Error handling
    cmd = "cp -a #{encrypted_file_path} #{perm_path}"
    system cmd

    LocalFile.create(backup_id: backup.id,
                     name: backup.safe_name,
                     extension: extension, path: perm_path)
  end

  def extension
    "#{compression.extension}.#{encryption.extension}"
  end
end
