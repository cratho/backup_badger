Sequel.migration do
  change do
    create_table :protocol_google_drive_objects do
      # Keys & Structure
      foreign_key :id, :protocol_objects, null: false

      # Attributes
      String :google_ref, null: false
    end
  end
end
