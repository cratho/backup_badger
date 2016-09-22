Sequel.migration do
  change do
    create_table :compression_tar_bzips do
      primary_key :id
    end
  end
end
