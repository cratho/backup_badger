Sequel.migration do
  change do
    create_table :transaction_log_messages do
      # Keys & Structure
      primary_key :id
      foreign_key :transaction_log_id, :transaction_logs, null: false

      # Attributes
      Text        :message

      # Timestamps
      DateTime    :created_at, null: false
      DateTime    :updated_at
    end
  end
end
