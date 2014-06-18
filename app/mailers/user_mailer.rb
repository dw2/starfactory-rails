class UserMailer < ActionMailer::Base
  default from: "notifications@starfactory.co"
  
  def activation_needed_email(user)
    @user = user
    @url  = user_token_activate_url(token: user.activation_token, host: host)
    send_mail __method__
  end
  
  def activation_success_email(user)
    @user = user
    @url  = login_url(host: host)
    send_mail __method__
  end
  
  def reset_password_email(user)
    @user = user
    @url = edit_password_reset_url(user.reset_password_token, host: host)
    send_mail __method__
  end

private
  def host
    ActionMailer::Base.default_url_options[:host]
  end

  def send_mail(view)
    mail to: @user.email, subject: I18n.t("user_mailer.#{view}.subject")
  end
end