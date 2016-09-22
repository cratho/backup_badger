namespace :backup_rotation do
  desc 'Create a BackupRotation from JSON'
  task :create, [:args_expr] => [:environment] do |_t, args|
    args.with_defaults(args_expr: 'json_file_path')
    h = Rack::Utils.parse_nested_query(args[:args_expr])

    json_file_path = h['json_file_path']
    backup_rotation = BackupRotation.create_from json_file_path

    pp backup_rotation
  end
end
