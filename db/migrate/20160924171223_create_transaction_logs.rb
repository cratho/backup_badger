Sequel.migration do
  change do
    create_table :transaction_logs do
      # Keys & Structure
      primary_key :id
      foreign_key :transaction_id, :transactions, null: false

      # Attributes
      Boolean     :successful, null: false, default: false

      # Timestamps
      DateTime    :created_at, null: false
      DateTime    :updated_at
    end
  end
end
