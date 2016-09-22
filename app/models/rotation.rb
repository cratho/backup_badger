# Class to model a Rotation
class Rotation < Sequel::Model
  plugin :class_table_inheritance, key: :content_type
  plugin :timestamps
  one_to_many :backup_rotations

  # Look for and create any new transactions for this rotation
  def generate_transactions
  end
end
