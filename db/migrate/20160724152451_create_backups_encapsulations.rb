Sequel.migration do
  change do
    create_table :backups_encapsulations do
      # Keys & Structure
      primary_key :id
      foreign_key :encapsulation_id,  :encapsulations,  null: false
      foreign_key :backup_id,         :backups,         null: false
    end
  end
end
