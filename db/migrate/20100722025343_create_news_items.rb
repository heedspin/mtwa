class CreateNewsItems < ActiveRecord::Migration
  def self.up
    create_table :news_items do |t|
      t.integer :status_id, :default => Status.draft.id
      t.integer :news_type_id, :default => NewsType.news.id
      t.integer :position
      t.boolean :home_page, :default => true
      t.string :title
      t.text :summary
      t.text :body
      t.string :location
      t.datetime :publish_date
      t.string :image_caption
      t.string :image_url, :limit => 1024
      t.string   :image_file_name
      t.string   :image_content_type
      t.integer  :image_file_size
      t.datetime :image_updated_at
      t.integer :show_image_mode_id, :default => ShowImageMode.small.id
      t.string :attachment_title
      t.string   :attachment_file_name
      t.string   :attachment_content_type
      t.integer  :attachment_file_size
      t.datetime :attachment_updated_at
      t.userstamps
      t.timestamps
    end
  end

  def self.down
    drop_table :news_items
  end
end
