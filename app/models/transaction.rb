# Parent Class for modelling Transactions
class Transaction < Sequel::Model
  plugin :class_table_inheritance, key: :content_type
  plugin :timestamps

  many_to_one :backup_rotation
  many_to_one :protocol_object
  one_through_one :local_file

  def process
  end

  def folder_protocol
    folder = protocol_object
    protocol = folder.protocol
    raise "Unable to find protocol for #{self}" unless protocol
    [folder, protocol]
  end
end
