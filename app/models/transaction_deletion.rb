# Class to model a Deletion Transaction
class TransactionDeletion < Transaction
  many_to_one :transaction_upload
  def process
    return if scheduled_time > Time.now
    protocol, transaction_log = protocol_transaction_log

    tupo = transaction_upload.protocol_object

    begin
      help_process(protocol, tupo)
      transaction_log.success!
    rescue StandardError => e
      m = "ERROR: Could not delete #{tupo} on #{protocol} #{e}"
      TransactionLogMessage.create(message: m)
    end
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
