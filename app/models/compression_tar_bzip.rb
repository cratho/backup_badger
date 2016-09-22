# Class to model *nix based tar.bz2
class CompressionTarBZip < Compression
  require 'tempfile'

  def create_temp_file(backup)
    name      = backup.safe_name
    # path      = File.expand_path(backup.tmp_path)
    path      = backup.tmp_path
    # TODO: Error handling
    file = Tempfile.new("#{name}_", File.expand_path(path))
    files_from = "--files-from=#{backup.globfile}"
    exclude_from = "--exclude-from=#{backup.globfile(true)}"

    cmd = "tar -cjpf #{file.path} #{files_from} #{exclude_from}"
    puts cmd
    system cmd

    # TODO: Return un-expand_path or something like that
    #       So that full paths are not in DB
    File.join(path, Pathname.new(file.path).basename)
  end

  def extension
    'tar.bz2'
  end
end
