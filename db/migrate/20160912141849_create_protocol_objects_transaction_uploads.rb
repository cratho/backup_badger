Sequel.migration do
  change do
    create_table :protocol_objects_transaction_uploads do
      primary_key :id
      foreign_key :transaction_upload_id, :transactions,  null: false
      foreign_key :protocol_object_id, :protocol_objects, null: false
    end
  end
end
