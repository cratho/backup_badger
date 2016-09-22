Sequel.migration do
  change do
    create_table :transaction_uploads do
      # Keys & Structure
      foreign_key :id, :transactions, null: false

      # Attributes
      String      :remote_filename, null: false
    end
  end
end
