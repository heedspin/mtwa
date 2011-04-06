class CreateS3Uploads < ActiveRecord::Migration
  def self.up
    create_table :s3_uploads, :force => true do |t|
      t.references :mt_hit
      t.string :assignment_id
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at
      t.integer :survey_id
      t.string :survey_type
      t.timestamps
    end
  end

  def self.down
    drop_table :s3_uploads
  end
end