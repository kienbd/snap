class UserMailer < ActionMailer::Base
  default from: "snapa.lifetime@gmail.com"

  def invite(email)
    @email = email
    @root_url = root_url
    mail(:to => email, :subject => "Invite")
  end

  def reset(recipient)
    @edit_password_reset_url = edit_password_reset_url(recipient.persistence_token)
    mail(:to => recipient.email, :subject => "Password Reset Instructions")
  end

  def verify(recipient)
    @user_verification_url = verification_url(recipient.persistence_token)
    mail(:to => recipient.email, :subject => "verification Instructions")
  end

  def sharePhoto(from, name_to, mail_to, message, photo)
    @name_to = name_to
    @message = message
    @url = "http://#{Settings.hostname}#{photo_path(photo.id)}"
    @photo = photo
    @from = from
    mail(to: mail_to, subject: "Your firend, #{from} share a photo")
  end

end
