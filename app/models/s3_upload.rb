class S3Upload < ApplicationModel
	belongs_to :survey, :polymorphic => true

  has_attached_file( :file,
                     :storage => :s3,
                     :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
                     :url => ':s3_domain_url',
                     :path => ":survey_type/:basename.:extension" )
end

Paperclip.interpolates :survey_type do |attachment, style|
  s3_upload = attachment.instance
  if s3_upload.survey_type
    s3_upload.survey_type.demodulize.tableize.singularize
  else
    'lost_and_found'
  end
end


# == Schema Information
#
# Table name: s3_uploads
#
#  id                :integer(4)      not null, primary key
#  mt_hit_id         :integer(4)
#  assignment_id     :string(255)
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer(4)
#  file_updated_at   :datetime
#  survey_id         :integer(4)
#  survey_type       :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

