require 'mt_task'
class MtPdfSurvey < ApplicationModel
  include MtTask
  belongs_to :mt_hit
  belongs_to :mt_answer_status
end

# == Schema Information
#
# Table name: mt_pdf_surveys
#
#  id            :integer(4)      not null, primary key
#  title         :string(255)
#  material      :text
#  finish        :text
#  notes         :text
#  mturk_hit_id  :integer(4)
#  assignment_id :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
