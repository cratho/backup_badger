Sequel.migration do
  change do
    create_table :transactions do
      # Keys & Structure
      primary_key :id
      String      :content_type,                          null: false
      foreign_key :backup_rotation_id, :backup_rotations, null: false
      foreign_key :protocol_object_id, :protocol_objects, null: false # Folder

      # Attributes
      Date        :scheduled_date,  null: false
      Time        :scheduled_time,  null: false
      Boolean     :completed,       null: false, default: false

      # Timestamps
      DateTime    :created_at, null: false
      DateTime    :updated_at
    end
  end
end
