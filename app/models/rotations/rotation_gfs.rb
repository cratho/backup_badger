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
    # Do not generate a daily if there is a weekly to do etc.
    # If the script is run multiple times on the same day
    #   it will progress a level farther each time
    return if yearlies(br, folder)
    return if monthlies(br, folder)
    return if weeklies(br, folder)
    return if dailies(br, folder)
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
    today = Date.today
    sched_time = today.at_beginning_of_week
    deletion_time = (sched_time + 7)
    n = sched_time.cweek.to_s.rjust(2, '0')
    create_transactions br, folder, "WEEKLY_#{n}", deletion_time, sched_time
  end

  # br => backup_rotation
  def monthlies(br, folder)
    today = Date.today
    sched_time = Date.new(today.year, today.month, 1)
    deletion_time = Date.new(today.year, today.month + 1, 1)
    n = sched_time.month.to_s.rjust(2, '0')
    create_transactions br, folder, "MONTHLY_#{n}", deletion_time, sched_time
  end

  # br => backup_rotation
  def yearlies(br, folder)
    today = Date.today
    sched_time = Date.new(today.year, 1, 1)
    deletion_time = Date.new(today.year + 1, 1, 1)
    n = sched_time.year.to_s
    create_transactions br, folder, "YEARLY_#{n}", deletion_time, sched_time
  end

  def create_transactions(backup_rotation,
                          folder, prefix, deletion_time = nil,
                          sched_time = Time.now)

    t = create_transaction_upload(
      backup_rotation, folder, safe_name(backup_rotation, prefix), sched_time
    )

    if t
      t.local_file = backup_rotation.backup.encapsulate_targets
      return create_transaction_deletion deletion_time, t
    end
    nil
  end

  def safe_name(backup_rotation, prefix)
    sn = backup_rotation.backup.safe_name
    "#{prefix}_#{sn}"
  end

  def create_transaction_deletion(sched_time, transaction_upload)
    return nil if find_td(sched_time, transaction_upload)
    TransactionDeletion.create(
      backup_rotation_id:     transaction_upload.backup_rotation_id,
      protocol_object_id:     transaction_upload.protocol_object_id,
      transaction_upload_id:  transaction_upload.id,
      scheduled_date:         sched_time
    ) do |a|
      a.scheduled_time = sched_time
    end
  end

  def find_td(sched_time, transaction_upload)
    TransactionDeletion.find(
      backup_rotation_id:     transaction_upload.backup_rotation_id,
      protocol_object_id:     transaction_upload.protocol_object_id,
      transaction_upload_id:  transaction_upload.id,
      scheduled_date:         sched_time
    )
  end

  def create_transaction_upload(backup_rotation, protocol_object,
                                remote_filename, sched_time = Time.now)
    return nil if find_tu(backup_rotation, protocol_object, sched_time)
    TransactionUpload.create(
      backup_rotation_id:   backup_rotation.id,
      protocol_object_id:   protocol_object.id,
      scheduled_date:       sched_time
    ) do |a|
      a.scheduled_time = sched_time
      a.remote_filename = remote_filename
    end
  end

  def find_tu(backup_rotation, protocol_object, sched_time)
    TransactionUpload.find(
      backup_rotation_id:   backup_rotation.id,
      protocol_object_id:   protocol_object.id,
      scheduled_date:       sched_time
    )
  end
end
