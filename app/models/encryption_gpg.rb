# Class to model GPG Encryption
class EncryptionGPG < Encryption
  def create_temp_file(input_path)
    # TODO: Get this from a devise user
    cmd = "gpg --batch --yes --output #{input_path} --encrypt\
      --recipient 'Craig Thomson' #{input_path}"
    # TODO: Error handling
    system cmd
    input_path
  end

  def extension
    'gpg'
  end
end
