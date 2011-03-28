require 'active_hash/super_enum'
class QuoteStatus < ActiveHash::Base
  include ActiveHash::SuperEnum
  self.data = [
    {:id => 1, :name => 'New', :method => :new_quote },
    {:id => 2, :name => 'Deleted'}
  ]
  enum_accessor :name
end
