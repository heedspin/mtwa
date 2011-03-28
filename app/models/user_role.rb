require 'active_hash/super_enum'
class UserRole < ActiveHash::Base
  include ActiveHash::SuperEnum
  self.data = [
    { :id => 1, :name => 'Admin' },
    { :id => 2, :name => 'User'}
  ]
  enum_accessor :name
end
