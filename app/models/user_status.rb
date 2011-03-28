require 'active_hash/super_enum'
class UserStatus < ActiveHash::Base
  include ActiveHash::SuperEnum
  self.data = [
    {:id => 1, :name => 'Unconfirmed'},
    {:id => 2, :name => 'Active'},
    {:id => 3, :name => 'Suspended'},
    {:id => 4, :name => 'Deleted'}
  ]
  enum_accessor :name
end
