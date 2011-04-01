require 'active_hash/super_enum'
class SurveyType < ActiveHash::Base
  include ActiveHash::SuperEnum
  self.data = [
    {:id => 1, :name => 'Bailiwick', :key => 'bailiwick'},
  ]
  enum_accessor :key
end
