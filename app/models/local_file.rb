# Class to model a locally stored file
class LocalFile < Sequel::Model
  require 'digest'

  plugin :timestamps
  many_to_one   :backup
  many_to_many  :transactions

  def md5_checksum
    (Digest::MD5.file File.expand_path(path)).to_s
  end

  def delete_file
    FileUtils.rm(File.expand_path(path))
    self.deleted = true
    save
  end
end
