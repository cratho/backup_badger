# Class to model the optional/multiple message text of TransactionLog
class TransactionLogMessage < Sequel::Model
  plugin :timestamps
  many_to_one :transaction_log
end
