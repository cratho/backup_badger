Sequel.migration do
  change do
    create_table :local_files do
      # Keys & Structure
      primary_key :id
      foreign_key :backup_id, :backups, null: false

      # Attributes
      String      :name,      null: false
      String      :extension, null: false
      String      :path,      null: false
      Boolean     :deleted,   null: false, default: false

      # Timestamps
      DateTime    :created_at, null: false
      DateTime    :updated_at
    end
  end
end
