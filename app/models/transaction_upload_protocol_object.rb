# Class to model the relation of TUs to POs
class TransactionUploadProtocolObject < Sequel::Model
  many_to_one :transaction_upload
  many_to_one :protocol_object
end
