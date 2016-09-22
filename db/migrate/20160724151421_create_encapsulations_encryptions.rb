Sequel.migration do
  change do
    create_table :encapsulations_encryptions do
      # Keys & Structure
      primary_key :id
      foreign_key :encapsulation_id,  :encapsulations,  null: false
      foreign_key :encryption_id,     :encryptions,     null: false
    end
  end
end
