Sequel.migration do
  change do
    create_table :backups_targets do
      # Keys & Structure
      primary_key :id
      foreign_key :backup_id,  :backups,  null: false
      foreign_key :target_id,  :targets,  null: false
    end
  end
end
