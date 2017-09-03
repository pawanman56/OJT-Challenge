# Preview all emails at http://localhost:3000/rails/mailers/user_mail_mailer
class UserMailMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mail_mailer/account_activation
  def account_activation
    UserMailMailer.account_activation
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mail_mailer/password_reset
  def password_reset
    UserMailMailer.password_reset
  end

end
