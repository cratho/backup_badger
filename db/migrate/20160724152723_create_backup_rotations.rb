Sequel.migration do
  change do
    create_table :backup_rotations do
      # Keys & Structure
      primary_key :id
      foreign_key :backup_id,   :backups,   null: false
      foreign_key :rotation_id, :rotations, null: false
      unique [:backup_id, :rotation_id]

      # Timestamps
      DateTime    :created_at, null: false
      DateTime    :updated_at
    end
  end
end
