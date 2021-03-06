require 'mt_task'
class MtPdfSurvey < ApplicationModel
  include MtTask
  belongs_to :survey_type
  belongs_to :mt_hit
  belongs_to :mt_answer_status
  belongs_to :subpage
  has_many :s3_uploads, :as => :survey
  
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
  
  attr_accessor :table1
  attr_accessor :table2
  
  def table1
    @table1 ||= self.table1_data.present? && JSON.parse(self.table1_data)
  end
  
  def table2
    @table2 ||= self.table2_data.present? && JSON.parse(self.table2_data)
  end
  
  protected
  
    before_save :encode_table_data
    def encode_table_data
      self.table1_data = @table1 && @table1.to_json
      self.table2_data = @table2 && @table2.to_json
      true
    end
    
    before_save :find_uploads
    def find_uploads
      if self.mt_hit and self.assignment_id.present?
        self.s3_uploads = self.mt_hit.s3_uploads.for_assignment(self.assignment_id).all
      end
      true
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

