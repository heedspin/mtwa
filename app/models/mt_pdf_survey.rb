require 'mt_task'
class MtPdfSurvey < ApplicationModel
  include MtTask
  belongs_to :survey_type
  belongs_to :mt_hit
  belongs_to :mt_answer_status
  belongs_to :subpage
  
  def asset_path
    "/assets/#{self.survey_type.key}/#{self.page}.pdf"
  end
  
  def page_identifier
    case self.product_on_page
    when 'first'
      "First Product On Page"
    when 'second'
      "Second Product on Page"
    else
      "Product on Page"
    end
  end
end



# == Schema Information
#
# Table name: mt_pdf_surveys
#
#  id                  :integer(4)      not null, primary key
#  page                :integer(4)
#  survey_type_id      :integer(4)
#  subpage_id          :integer(4)
#  title               :string(255)
#  material            :text
#  finish              :text
#  notes               :text
#  table1_title        :string(255)
#  table1_data         :text
#  table2_title        :string(255)
#  table2_data         :text
#  mt_hit_id           :integer(4)
#  assignment_id       :string(255)
#  mt_answer_status_id :integer(4)
#  feedback            :text
#  upload_file_name    :string(255)
#  upload_content_type :string(255)
#  upload_file_size    :integer(4)
#  upload_updated_at   :datetime
#  created_at          :datetime
#  updated_at          :datetime
#

