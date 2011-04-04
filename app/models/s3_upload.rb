class S3Upload < ApplicationModel
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
#  created_at        :datetime
#  updated_at        :datetime
#

