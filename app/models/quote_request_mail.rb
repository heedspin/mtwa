class QuoteRequestMail < ActionMailer::Base
  def quote_request(quote_request)
    @quote_request = quote_request
    mail( :subject =>"[#{AppConfig.company_name} Quote Request] from #{quote_request.name_email}",
          :from => AppConfig.email_address,
          :reply_to => quote_request.reply_to_email,
          :to => AppConfig.quote_request_recipients,
          :date => quote_request.created_at )
  end
end
