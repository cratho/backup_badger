Sequel.migration do
  change do
    create_table :transaction_deletions do
      # Keys & Structure
      foreign_key :id, :transactions,                    null: false
      foreign_key :transaction_upload_id, :transactions, null: false
    end
  end
end
