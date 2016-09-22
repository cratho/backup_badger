# Parent class to model methods of encryption
class Encryption < Sequel::Model
  plugin :class_table_inheritance, key: :content_type
  plugin :timestamps
  one_through_one :encapsulation
end
