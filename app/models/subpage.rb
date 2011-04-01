require 'active_hash/super_enum'
class Subpage < ActiveHash::Base
  include ActiveHash::SuperEnum
  self.data = [
    {:id => 1, :name => 'Only'},
    {:id => 2, :name => 'First', :method => :first_subpage},
    {:id => 3, :name => 'Second ', :method => :second_subpage}
  ]
  enum_accessor :name
end
