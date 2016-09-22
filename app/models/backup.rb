# Class to model a Backup
class Backup < Sequel::Model
  require 'tempfile'

  plugin :timestamps
  many_to_one       :user
  one_through_one   :encapsulation
  many_to_many      :targets
  one_to_many       :backup_rotations
  one_to_many       :local_files

  def encapsulate_targets
    encapsulation.create_local_file
  end

  def set_encapsulation(encapsulation, compression = nil, encryption = nil)
    encapsulation.compression = compression if compression
    encapsulation.encryption  = encryption if encryption

    self.encapsulation = encapsulation
  end

  def find_backup_rotation(rotation)
    BackupRotation.find(
      backup_id: id,
      rotation_id: rotation.id
    )
  end

  def glob_lines(exclude = false)
    out_lines = []
    targets.each do |target|
      lines = target.glob_lines(exclude)
      out_lines.push(*lines)
    end
    out_lines.uniq
  end

  def globfile(exclude = false)
    t = Tempfile.new('glob')
    File.open(t.path, 'w+') do |f|
      f.puts(glob_lines(exclude))
    end
    t.close
    t.path
  end

  def safe_name
    n = name
    n.tr!(' ', '_')
    n.gsub!(/\W/, '')
    n
  end
end
