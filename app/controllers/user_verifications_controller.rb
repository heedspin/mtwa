class UserVerificationsController < ApplicationController
  skip_before_filter :require_login, :only => [:show]

  def show
    if @user = User.find_using_perishable_token(params[:id])
      @user.verify!
      flash[:notice] = "Thank you for verifying your account. You may now login."
      redirect_to login_url
    else
      flash[:notice] = "This verification token has expired.  You must reset your password to access your account."
      redirect_to new_password_reset_url
    end
  end

end
