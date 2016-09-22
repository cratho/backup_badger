Sequel.migration do
  change do
    # For the root folders / nodes of each protocol
    create_table :backup_rotations_protocol_objects do
      # Keys & Structure
      primary_key :id
      foreign_key :backup_rotation_id,  :backup_rotations,  null: false
      foreign_key :protocol_object_id,  :protocol_objects,  null: false
      unique [:backup_rotation_id, :protocol_object_id]
    end
  end
end
