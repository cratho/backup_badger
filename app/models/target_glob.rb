# Class to model a single line of a globfile
class TargetGlob < Sequel::Model
  plugin :timestamps
  many_to_one :target
end
