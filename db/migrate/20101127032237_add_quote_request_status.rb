class AddQuoteRequestStatus < ActiveRecord::Migration
  def self.up
    add_column :quote_requests, :quote_status_id, :integer, :default => QuoteStatus.new_quote.id
    execute "update quote_requests set quote_status_id = #{QuoteStatus.new_quote.id}"
  end

  def self.down
    remove_column :quote_requests, :quote_status_id
  end
end