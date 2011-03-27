=begin Schema Information

 Table name: news_items

  id                      :integer(4)      not null, primary key
  status_id               :integer(4)      default(1)
  news_type_id            :integer(4)      default(1)
  position                :integer(4)
  home_page               :boolean(1)      default(TRUE)
  title                   :string(255)
  summary                 :text
  body                    :text
  location                :string(255)
  publish_date            :datetime
  image_caption           :string(255)
  image_url               :string(1024)
  image_file_name         :string(255)
  image_content_type      :string(255)
  image_file_size         :integer(4)
  image_updated_at        :datetime
  show_image_mode_id      :integer(4)      default(2)
  attachment_title        :string(255)
  attachment_file_name    :string(255)
  attachment_content_type :string(255)
  attachment_file_size    :integer(4)
  attachment_updated_at   :datetime
  creator_id              :integer(4)
  updater_id              :integer(4)
  created_at              :datetime
  updated_at              :datetime

=end Schema Information

class NewsItem < ApplicationModel
  belongs_to :status
  belongs_to :news_type
  belongs_to :show_image_mode
  acts_as_list
  after_create :move_to_top
  BUCKET = Rails.env.production? ? 'smtcoinc' : 'smtcoinc-dev'
  has_attached_file( :image, :whiny => false,
                     :styles => {:show => '200>', :index => '100>', :edit => '100>', :thumbnail => '100>', :medium => '400>', :large => '600>' },
                     :storage => :s3,
                     :s3_credentials => "#{Rails.root}/config/s3.yml",
                     :url => ':s3_domain_url',
                     :path => ":class/:attachment/:id/:style/:basename.:extension",
                     :bucket => BUCKET )
  has_attached_file( :attachment,
                     :storage => :s3,
                     :s3_credentials => "#{Rails.root}/config/s3.yml",
                     :url => ':s3_domain_url',
                     :path => ":class/:attachment/:id/:style/:basename.:extension",
                     :bucket => BUCKET )

  scope :by_position, :order => :position
  after_create :move_to_top

  scope :not_deleted, lambda {
    {
      :conditions => ['news_items.status_id != ?', Status.deleted.id]
    }
  }

  scope :on_home_page, :conditions => { :home_page => true }
  
  def destroy
    self.update_attributes(:status_id => Status.deleted.id)
    self.remove_from_list
  end
  
  def move!(direction)
    case direction
    when 'up'
      self.move_higher
    when 'down'
      self.move_lower
    when 'top'
      self.move_to_top
    when 'bottom'
      self.move_to_bottom
    end
  end

  protected

    clean_urls :image_url
    
    after_update :reposition
    def reposition
      if !self.status.deleted? and self.position.nil?
        self.insert_at(1)
      end
    end

end

# == Schema Information
#
# Table name: news_items
#
#  id                      :integer(4)      not null, primary key
#  status_id               :integer(4)      default(1)
#  news_type_id            :integer(4)      default(1)
#  position                :integer(4)
#  home_page               :boolean(1)      default(TRUE)
#  title                   :string(255)
#  summary                 :text
#  body                    :text
#  location                :string(255)
#  publish_date            :datetime
#  image_caption           :string(255)
#  image_url               :string(1024)
#  image_file_name         :string(255)
#  image_content_type      :string(255)
#  image_file_size         :integer(4)
#  image_updated_at        :datetime
#  show_image_mode_id      :integer(4)      default(2)
#  attachment_title        :string(255)
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer(4)
#  attachment_updated_at   :datetime
#  creator_id              :integer(4)
#  updater_id              :integer(4)
#  created_at              :datetime
#  updated_at              :datetime
#

