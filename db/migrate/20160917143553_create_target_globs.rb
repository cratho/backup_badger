Sequel.migration do
  change do
    create_table :target_globs do
      # Keys & Structure
      primary_key :id
      foreign_key :target_id, :targets, null: false

      # Attributes
      String      :line, null: false

      # Timestamps
      DateTime    :created_at, null: false
      DateTime    :updated_at
    end
  end
end
