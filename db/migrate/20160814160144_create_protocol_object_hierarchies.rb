Sequel.migration do
  change do
    create_table :protocol_object_hierarchies do
      # Keys & Structure
      primary_key :id
      foreign_key :parent_id, :protocol_objects
      foreign_key :child_id,  :protocol_objects

      # Timestamps
      DateTime    :created_at, null: false
      DateTime    :updated_at
    end
  end
end
