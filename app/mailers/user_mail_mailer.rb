class UserMailMailer < ApplicationMailer

  def account_activation(user, activation_token)
    @user = user
    @activation_token = activation_token
    mail to: @user.email, subject: "Account activation"
  end

  def password_reset(user, reset_token)
    @user = user
    @reset_token = reset_token
    mail to: @user.email, subject: "Password reset"
  end
end
