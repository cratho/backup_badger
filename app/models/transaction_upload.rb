# Class to model a TransactionUpload
class TransactionUpload < Transaction
  one_to_many :transaction_deletions
  one_through_one :protocol_object

  def process
    folder, protocol, transaction_log = folder_protocol_transaction_log
    begin
      help_process(folder, protocol)
      transaction_log.success!
    rescue StandardError => e
      TransactionLogMessage.create(
        transaction_log_id: transaction_log.id,
        message: "ERROR: Could not send #{remote_filename} to #{protocol} #{e}"
      )
    end
  end

  def help_process(folder, protocol)
    self.remote_filename = "#{remote_filename}.#{local_file.extension}"
    save
    po = protocol.send(
      local_file.path, remote_filename, folder
    )
    self.protocol_object = po
    self.completed = true
    save
    verify_md5(po, local_file)
  end

  def verify_md5(po, local_file)
    protocol = po.protocol
    if protocol.validate_protocol_object(po, local_file)
      local_file.delete_file
    else
      puts "WARN: ProtocolObject #{po.id} not validated"
    end
  end
end
