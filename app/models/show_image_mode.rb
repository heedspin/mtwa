require 'active_hash_methods'
class ShowImageMode < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Not Shown'},
    {:id => 2, :name => 'Small'},
    {:id => 3, :name => 'Large'},
  ]
  include ActiveHashMethods
end
