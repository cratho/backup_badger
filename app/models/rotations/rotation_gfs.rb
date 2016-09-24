# Class for a Grandfather, Father, Son Rotation
class RotationGFS < Rotation
  # Look for and create any new transactions for this rotation
  def generate_transactions
    # TODO: Put in superclass as it is not dependant on drive
    backup_rotations.each do |backup_rotation|
      backup_rotation.folders.each do |folder|
        # TODO: Different folders, perhaps using a RotationElement class
        help_generate_transactions backup_rotation, folder
      end
    end
  end

  # br => backup_rotation
  def help_generate_transactions(br, folder)
    yearlies(br, folder)
    monthlies(br, folder)
    weeklies(br, folder)
    dailies(br, folder)
  end

  # br => backup_rotation
  def dailies(br, folder)
    deletion_time = (Date.today + 7)
    sched_time = Date.today
    n = sched_time.wday.to_s.rjust(2, '0')
    create_transactions br, folder, "DAILY_#{n}", deletion_time, sched_time
  end

  # br => backup_rotation
  def weeklies(br, folder)
    sched_time = Date.today.at_beginning_of_week
    deletion_time = (sched_time + 7)
    n = sched_time.cweek.to_s.rjust(2, '0')
    create_transactions br, folder, "WEEKLY_#{n}", deletion_time, sched_time
  end

  # br => backup_rotation
  def monthlies(br, folder)
    now = Date.today
    sched_time = Date.new(now.year, now.month, 1)
    deletion_time = Date.new(now.year, now.month + 1, 1)
    n = sched_time.month.to_s.rjust(2, '0')
    create_transactions br, folder, "MONTHLY_#{n}", deletion_time, sched_time
  end

  # br => backup_rotation
  def yearlies(br, folder)
    now = Date.today
    sched_time = Date.new(now.year, 1, 1)
    deletion_time = Date.new(now.year + 1, 1, 1)
    n = sched_time.year.to_s
    create_transactions br, folder, "YEARLY_#{n}", deletion_time, sched_time
  end

  def create_transactions(backup_rotation,
                          folder, prefix,
                          deletion_time = nil,
                          scheduled_time = Time.now)
    local_file = backup_rotation.backup.encapsulate_targets
    name = safe_name(backup_rotation, prefix)

    t = create_upload_transaction(
      backup_rotation, folder, name, scheduled_time
    )

    t.local_file = local_file
    create_deletion_transaction deletion_time, t
  end

  def safe_name(backup_rotation, prefix)
    sn = backup_rotation.backup.safe_name
    "#{prefix}_#{sn}"
  end

  def create_deletion_transaction(scheduled_time, upload_transaction)
    TransactionDeletion.find_or_create(
      backup_rotation_id:     upload_transaction.backup_rotation_id,
      protocol_object_id:     upload_transaction.protocol_object_id,
      transaction_upload_id:  upload_transaction.id,
      scheduled_date:         scheduled_time
    ) do |a|
      a.scheduled_time = scheduled_time
    end
  end

  def create_upload_transaction(backup_rotation, protocol_object,
                                remote_filename,
                                scheduled_time = Time.now)
    TransactionUpload.find_or_create(
      backup_rotation_id:   backup_rotation.id,
      protocol_object_id:   protocol_object.id,
      scheduled_date:       scheduled_time,
      remote_filename:      remote_filename
    ) do |a|
      a.scheduled_time = scheduled_time
    end
  end
end
