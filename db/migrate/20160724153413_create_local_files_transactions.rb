Sequel.migration do
  change do
    create_table :local_files_transactions do
      # Keys & Structure
      primary_key :id
      foreign_key :local_file_id,   :local_files,   null: false
      foreign_key :transaction_id,  :transactions,  null: false
    end
  end
end
