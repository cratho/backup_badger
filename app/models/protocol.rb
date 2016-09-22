# Protocol is a method for sending files to a remote location
class Protocol < Sequel::Model
  plugin :class_table_inheritance, key: :content_type
  plugin :timestamps
  one_to_many :protocol_objects
  one_to_many :transactions

  def connect
  end

  # TODO: Some kind of list / integrity checking

  # TODO: Place all of the common protocol methods here
  #       some in ProtocolGoogleDrive are not listed yet

  def find(name, protocol_folder = nil)
  end

  def create_folders_from(path)
  end

  def root_object
  end
end
