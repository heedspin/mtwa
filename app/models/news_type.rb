require 'active_hash_methods'
class NewsType < ActiveHash::Base
  self.data = [
    {:id => 1,   :name => 'News'},
    {:id => 2, :name => 'Press Release'},
  ]
  include ActiveHashMethods
end
