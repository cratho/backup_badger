# Class to model an individual attempt at a transaction
class TransactionLog < Sequel::Model
  plugin :timestamps
  one_to_many :transaction_log_messages
  many_to_one :transaction

  def success!
    self.successful = true
    save
  end
end
