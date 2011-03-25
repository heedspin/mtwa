require 'active_hash_methods'
class Status < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Draft'},
    {:id => 2, :name => 'Published'},
    {:id => 3, :name => 'Deleted'}
  ]
  include ActiveHashMethods
end
