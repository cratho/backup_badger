# Class to model a Deletion Transaction
class TransactionDeletion < Transaction
  many_to_one :transaction_upload
  def process
    return if scheduled_time > Time.now
    folder = protocol_object
    protocol = folder.protocol
    raise "Unable to find protocol for #{self}" unless protocol

    tu = transaction_upload.transaction_upload_protocol_objects
    msg = "Unable to find Protocol Object for #{transaction_upload}"
    raise msg unless tu.first

    help_process(protocol, tu)
  end

  def help_process(protocol, tu)
    to_delete = tu.first.protocol_object
    result = protocol.delete to_delete
    if result.nil?
      self.completed = true
      save
      to_delete.deleted = true
      to_delete.save
    end
  end
end
