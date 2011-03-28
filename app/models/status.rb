require 'active_hash/super_enum'
class Status < ActiveHash::Base
  include ActiveHash::SuperEnum
  self.data = [
    {:id => 1, :name => 'Draft'},
    {:id => 2, :name => 'Published'},
    {:id => 3, :name => 'Deleted'}
  ]
  enum_accessor :name
end
