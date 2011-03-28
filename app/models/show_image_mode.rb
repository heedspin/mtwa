require 'active_hash/super_enum'
class ShowImageMode < ActiveHash::Base
  include ActiveHash::SuperEnum
  self.data = [
    {:id => 1, :name => 'Not Shown'},
    {:id => 2, :name => 'Small'},
    {:id => 3, :name => 'Large'},
  ]
  enum_accessor :name
end
