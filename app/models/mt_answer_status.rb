require 'active_hash/super_enum'
class MtAnswerStatus < ActiveHash::Base
  include ActiveHash::SuperEnum
  self.data = [
    {:id => 1, :name => 'Reviewable'},
    {:id => 2, :name => 'Accepted'},
    {:id => 3, :name => 'Rejected'}
  ]
  enum_accessor :name
end
