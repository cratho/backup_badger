Sequel.migration do
  change do
    create_table :protocol_objects do
      # Keys & Structure
      primary_key :id
      String      :content_type, null: false
      foreign_key :protocol_id, :protocols, null: false

      # Attributes
      String  :name,    null: false
      Boolean :deleted, null: false, default: false

      # Timestamps
      DateTime    :created_at, null: false
      DateTime    :updated_at
    end
  end
end
