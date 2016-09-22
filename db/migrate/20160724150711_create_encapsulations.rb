Sequel.migration do
  change do
    create_table :encapsulations do
      # Keys & Structure
      primary_key :id
      String      :content_type, null: false

      # Attributes
      String      :name, null: false

      # Timestamps
      DateTime    :created_at, null: false
      DateTime    :updated_at
    end
  end
end
