=begin Schema Information

 Table name: quote_requests

  id                 :integer(4)      not null, primary key
  name               :string(255)
  company            :string(255)
  phone              :string(255)
  email              :string(255)
  address1           :string(255)
  address2           :string(255)
  state              :string(255)
  city               :string(255)
  zip                :string(255)
  country            :string(255)
  fax                :string(255)
  services           :string(255)
  lead_time          :string(255)
  annual_use         :string(255)
  release_value      :string(255)
  order_frequency_id :integer(4)
  note               :text
  subject            :string(255)
  created_at         :datetime
  updated_at         :datetime
  quote_status_id    :integer(4)      default(1)
  other_service      :string(255)

=end Schema Information

class QuoteRequest < ApplicationModel
  belongs_to :quote_status
  validates_presence_of :name
  belongs_to :order_frequency
  
  def reply_to_email
    if (legal_email = Mail::Address.new(self.email)) and legal_email.domain.present?
      self.name_email
    else
      nil
    end
  end

  def name_email
    "\"#{self.name}\" <#{self.email}>"
  end
  
  scope :not_deleted, lambda {
    {
      :conditions => ['quote_requests.quote_status_id != ?', QuoteStatus.deleted.id]
    }
  }  
  
  def self.fields
    result = [:name, :company, :phone, :email, :address1, :address2, :city, :state, :zip, :country, :fax, :services, :other_service, :lead_time, :annual_use, :release_value, :order_frequency, :note, :created_at]
    forgotten = self.columns.map(&:name).map(&:to_sym) - [:id, :updated_at, :quote_status_id, :order_frequency_id, :subject] - result
    if forgotten.size > 0
      raise "QuoteRequest.fields is missing #{forgotten.join(', ')}"
    end
    result
  end
  
  def destroy
    self.update_attributes(:quote_status_id => QuoteStatus.deleted.id)
  end
  
  def services=(ids)
    write_attribute(:services, ids.reject { |i| i.blank? }.join(','))
  end
  
  def services
    if v = read_attribute(:services)
      v.split(',').map { |id| Service.find_by_id(id) }
    else
      []
    end
  end
  
  protected
  
    validate :some_way_to_contact
    def some_way_to_contact
      if self.phone.blank? and self.email.blank? and self.fax.blank?
        errors.add(:base, 'Please fill in a phone number or email address for us to contact you.')
      end
    end
  
    before_create :ensure_status
    def ensure_status
      self.quote_status ||= QuoteStatus.new_quote
    end

    after_create :send_email

    def send_email
      # Assume that only a spam bot would fill in the hidden subject field.
      if self.subject.blank?
        unless AppConfig.quote_request_recipients.blank?
          QuoteRequestMail.quote_request(self).deliver
        end
      else
        logger.info("Spam filtered quote request with subject: " + self.subject)
      end
    end
end
