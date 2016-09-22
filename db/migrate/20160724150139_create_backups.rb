Sequel.migration do
  change do
    create_table :backups do
      # Keys & Structure
      primary_key :id
      foreign_key :user_id, :users, null: false

      # Attributes
      String      :name,     null: false, unique: true
      String      :tmp_path, null: false, default: '/tmp'

      # Timestamps
      DateTime    :created_at, null: false
      DateTime    :updated_at
    end
  end
end
