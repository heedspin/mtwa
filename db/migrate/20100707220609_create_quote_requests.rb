class CreateQuoteRequests < ActiveRecord::Migration
  def self.up
    create_table :quote_requests, :force => true do |t|
      t.string :name
      t.string :company
      t.string :phone
      t.string :email
      t.string :address1
      t.string :address2
      t.string :state
      t.string :city
      t.string :zip
      t.string :country
      t.string :fax
      t.string :services
      t.string :lead_time
      t.string :annual_use
      t.string :release_value
      t.references :order_frequency
      t.text :note
      t.string :subject
      t.timestamps
    end
  end

  def self.down
    drop_table :quote_requests
  end
end
