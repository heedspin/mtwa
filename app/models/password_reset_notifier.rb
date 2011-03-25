class PasswordResetNotifier < ApplicationMailer
  default_url_options[:host] = AppConfig.hostname

  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token, :host => AppConfig.hostname)
    mail( :subject => "#{AppConfig.company_name} Password Reset Instructions",
          :from => AppConfig.email_address,
          :to => user.email,
          :date => Time.now )
  end

end
