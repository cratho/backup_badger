Sequel.migration do
  change do
    create_table :compressions_encapsulations do
      # Keys & Structure
      primary_key :id
      foreign_key :encapsulation_id,  :encapsulations,  null: false
      foreign_key :compression_id,    :compressions,    null: false
    end
  end
end
