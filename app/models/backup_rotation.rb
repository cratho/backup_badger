# Class to link a Backup with a Rotation
class BackupRotation < Sequel::Model
  plugin :timestamps
  many_to_one   :backup
  many_to_one   :rotation
  many_to_many  :folders,
                left_key:   :backup_rotation_id,
                right_key:  :protocol_object_id,
                join_table: :backup_rotations_protocol_objects,
                class:      ProtocolObject
  one_to_many   :transactions

  # Class Methods
  class << self
    def create_from(json_file_path)
      json = JSON.parse(File.read(json_file_path))
      user = User.find(email: json['User']['email'])

      BackupRotation.create_backup_rotations(
        json['BackupRotations'],
        BackupRotation.create_backups(json['Backups'], user),
        BackupRotation.create_rotations(json['Rotations'])
      )
    end

    def create_targets(targets, backup)
      targets.each do |target_name, target_data|
        target = Target.create(name: target_name)
        target.backup = backup
        target_data.each do |path|
          TargetGlob.create(line: path, target_id: target.id)
        end
      end
    end

    def create_encapsulation(data, backup)
      # TODO: More of this can go in backup and cleanly
      data.each do |encapsulation_name, encapsulation_data|
        encapsulation = Encapsulation.find_or_create(name: encapsulation_name)
        compression   = create_compression(encapsulation_data['compression'])
        encryption    = create_encryption(encapsulation_data['encryption'])
        backup.set_encapsulation(encapsulation, compression, encryption)
      end
    end

    def create_compression(data)
      help_create_encapsulation(data['class'], data['name'])
    end

    def create_encryption(data)
      help_create_encapsulation(data['class'], data['name'])
    end

    def help_create_encapsulation(class_name, name)
      Object.const_get(class_name).find_or_create(name: name)
    end

    def create_rotations(rotation_data)
      rotations = {}
      rotation_data.each do |name, data|
        rotation_class = Object.const_get(data['class'])
        error_msg = "Unable to find Rotation Class '#{data['rotation_class']}'"
        raise error_msg unless rotation_class
        rotations[name] = rotation_class.find_or_create(name: name)
      end
      rotations
    end

    def create_backups(backup_data, user)
      backups = {}
      backup_data.each do |name, data|
        backup = help_create_backups(name, data, user)
        BackupRotation.create_targets(data['targets'], backup)
        BackupRotation.create_encapsulation(data['encapsulation'], backup)
        backups[name] = backup
      end
      backups
    end

    def help_create_backups(name, data, user)
      Backup.find_or_create(name: name) do |a|
        a.user_id = user.id
        a.tmp_path = data['tmp_path']
      end
    end

    def create_backup_rotations(backup_rotation_data, backups, rotations)
      backup_rotation_data.values.each do |data|
        backup    = backups[data['backup_name']]
        rotation  = rotations[data['rotation_name']]

        raise "No Backup Found: #{data['backup_name']}" unless backup
        raise "No Rotation Found: #{data['rotation_name']}" unless rotation

        help_create_backup_rotations(backup, rotation, data)
      end
    end

    def help_create_backup_rotations(backup, rotation, data)
      backup_rotation = backup.find_backup_rotation(rotation)

      if backup_rotation.nil?
        backup_rotation = BackupRotation.create(
          backup_id: backup.id,
          rotation_id: rotation.id
        )
        protocol = Protocol.find(name: data['protocol_name'])
        root = protocol.create_folders_from(data['protocol_root'])
        root.backup_rotation = backup_rotation
      end
    end
  end

  # Instance Methods

  def generate_transactions
    rotation.generate_transactions
  end
end
