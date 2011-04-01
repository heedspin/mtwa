class CreateMtPdfSurveys < ActiveRecord::Migration
  def self.up
    create_table :mt_pdf_surveys, :force => true do |t|
      t.integer :page
      t.references :survey_type
      t.references :subpage
      t.string :title
      t.text :material
      t.text :finish
      t.text :notes
      t.string :table1_title
      t.text :table1_data
      t.string :table2_title
      t.text :table2_data
      t.references :mt_hit
      t.string :assignment_id
      t.references :mt_answer_status
      t.text :feedback
      t.string :upload_file_name
      t.string :upload_content_type
      t.integer :upload_file_size
      t.datetime :upload_updated_at
      t.timestamps
    end
    
    add_index :mt_pdf_surveys, :assignment_id, :unique => true
  end

  def self.down
    drop_table :mt_pdf_surveys
  end
end