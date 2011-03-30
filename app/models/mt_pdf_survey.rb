require 'mt_task'
class MtPdfSurvey < ApplicationModel
  include MtTask
  belongs_to :mt_hit
  belongs_to :mt_answer_status
  
  def asset_path
    "/assets/#{self.key}/#{self.page}.pdf"
  end
end


# == Schema Information
#
# Table name: mt_pdf_surveys
#
#  id                  :integer(4)      not null, primary key
#  page                :integer(4)
#  key                 :string(255)
#  title               :string(255)
#  material            :text
#  finish              :text
#  notes               :text
#  mt_hit_id           :integer(4)
#  assignment_id       :string(255)
#  mt_answer_status_id :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#

