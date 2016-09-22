# Class to model a TransactionUpload
class TransactionUpload < Transaction
  one_to_many :transaction_deletions
  one_to_many :transaction_upload_protocol_objects
  def process
    # Send via protocol
    folder, protocol = folder_protocol
    begin
      help_process(folder, protocol)
    rescue StandardError => e
      # TODO: Some kind of proper error log
      puts "ERROR: Could not send #{remote_filename} to #{protocol} #{e}"
      require 'pp'
      pp e.backtrace
    end

    # TODO: Validate transaction
  end

  def help_process(folder, protocol)
    self.remote_filename = "#{remote_filename}.#{local_file.extension}"
    save
    po = protocol.send(
      local_file.path, remote_filename, folder
    )
    TransactionUploadProtocolObject.create(transaction_upload_id: id,
                                           protocol_object_id: po.id)
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
