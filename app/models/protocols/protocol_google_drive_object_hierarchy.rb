# Class to model parent-child relationship of ProtocolObject
class ProtocolGoogleDriveObjectHierarchy < ProtocolObjectHierarchy
  # Hooks
  def before_validation
    set_google_ref
  end

  # Other functions
  def set_google_ref
    # TODO: Error handling on this, and assocations
    po = ProtocolObject.first(id: parent_id)
    protocol = Protocol.first(id: po.protocol.id)
    service = protocol.connect
    # TODO: Do not set the google ref unless the Drive command succeeds
    parent_ref  = ProtocolObject.first(id: parent_id).google_ref
    child_ref   = ProtocolObject.first(id: child_id).google_ref

    update_parents(parent_ref, child_ref, service)
  end

  def update_parents(parent_ref, child_ref, service)
    # Retrieve the existing parents to remove
    file = service.get_file(child_ref, fields: 'parents')
    previous_parents = file.parents.join(',')
    # Move the file to the new folder
    service.update_file(child_ref,
                        add_parents: parent_ref,
                        remove_parents: previous_parents,
                        fields: 'id, parents')
  end
end
