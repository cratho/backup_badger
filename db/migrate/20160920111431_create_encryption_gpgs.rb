Sequel.migration do
  change do
    create_table :encryption_gpgs do
      primary_key :id
    end
  end
end
