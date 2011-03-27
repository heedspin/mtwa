class CreateMtPdfSurveys < ActiveRecord::Migration
  def self.up
    create_table :mt_pdf_surveys, :force => true do |t|
      t.string :title
      t.text :material
      t.text :finish
      t.text :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :mt_pdf_surveys
  end
end