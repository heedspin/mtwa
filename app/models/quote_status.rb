require 'active_hash_methods'
class QuoteStatus < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'New', :method => :new_quote },
    {:id => 2, :name => 'Deleted'}
  ]
  include ActiveHashMethods
end
