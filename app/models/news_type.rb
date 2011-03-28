require 'active_hash/super_enum'
class NewsType < ActiveHash::Base
  include ActiveHash::SuperEnum
  self.data = [
    {:id => 1, :name => 'News'},
    {:id => 2, :name => 'Press Release'},
  ]
  enum_accessor :name
end
