require 'active_hash/super_enum'
class MtHitStatus < ActiveHash::Base
  include ActiveHash::SuperEnum
  self.data = [
    {:id => 1, :name => 'In Progress'},
    {:id => 2, :name => 'Complete'},
    {:id => 3, :name => 'Archived'},
    {:id => 4, :name => 'Deleted'}
  ]
  enum_accessor :name
end
