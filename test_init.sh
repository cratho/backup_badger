sh ./reset_db.sh
bundle exec rake "backup_rotation:create[json_file_path=db/backup_rotations.json]"