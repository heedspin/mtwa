class CreateMtPdfSurveys < ActiveRecord::Migration
  def self.up
    create_table :mt_pdf_surveys, :force => true do |t|
      t.string :title
      t.text :material
      t.text :finish
      t.text :notes
      t.references :mt_hit
      t.string :assignment_id
      t.references :mt_answer_status
      t.timestamps
    end
    
    add_index :mt_pdf_surveys, :assignment_id, :unique => true
  end

  def self.down
    drop_table :mt_pdf_surveys
  end
end