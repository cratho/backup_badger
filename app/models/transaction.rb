# Parent Class for modelling Transactions
class Transaction < Sequel::Model
  plugin :class_table_inheritance, key: :content_type
  plugin :timestamps

  many_to_one :backup_rotation
  many_to_one :transaction_logs
  many_to_one :folder, key: :protocol_object_id, class: ProtocolObject
  one_through_one :local_file

  def process
  end

  def folder_protocol_transaction_log
    protocol = folder.protocol
    raise "Unable to find protocol for #{self}" unless protocol
    [folder, protocol, TransactionLog.create(transaction_id: id)]
  end

  def protocol_log
    _folder, protocol, transaction_log = folder_protocol_transaction_log
    [protocol, transaction_log]
  end
end
