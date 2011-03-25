class AddQuoteRequestOtherService < ActiveRecord::Migration
  def self.up
    add_column :quote_requests, :other_service, :string
  end

  def self.down
    remove_column :quote_requests, :other_service
  end
end