# CLass to model objects on a remote protocol
class ProtocolObject < Sequel::Model
  plugin :class_table_inheritance, key: :content_type
  plugin :timestamps

  one_through_one :parent,
                  class: :ProtocolObject,
                  join_table: :protocol_object_hierarchies,
                  left_key: :child_id, right_key: :parent_id

  many_to_many    :children,
                  class: :ProtocolObject,
                  join_table: :protocol_object_hierarchies,
                  left_key: :parent_id, right_key: :child_id

  many_to_one       :protocol
  one_through_one   :backup_rotation
  one_to_many       :transactions
  one_through_one   :transaction_upload
end
