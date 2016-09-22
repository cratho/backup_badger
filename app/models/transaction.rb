# Parent Class for modelling Transactions
class Transaction < Sequel::Model
  plugin :class_table_inheritance, key: :content_type
  plugin :timestamps

  many_to_one :backup_rotation
  many_to_one :folder, key: :protocol_object_id, class: ProtocolObject
  one_through_one :local_file

  def process
  end

  def folder_protocol
    protocol = folder.protocol
    raise "Unable to find protocol for #{self}" unless protocol
    [folder, protocol]
  end
end
