# Class to model a Target of a Backup
class Target < Sequel::Model
  plugin :timestamps
  plugin :class_table_inheritance, key: :content_type
  one_through_one :backup
  one_to_many :target_globs

  def glob_lines(exclude = false)
    out_lines = []
    TargetGlob.filter(exclude: exclude, target_id: id).each do |target_glob|
      line = File.expand_path(target_glob.line)
      x = line.gsub('\r\n', '\n')
      x = x.gsub('\r', '\n')
      lines = x.split('\n').reject(&:empty?)
      lines.each { |l| out_lines << l }
    end

    # TODO: uniq probably is not required, duplicates should not get in the DB
    out_lines.uniq
  end
end
