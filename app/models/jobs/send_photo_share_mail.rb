class Jobs::SendPhotoShareMail
  @queue = :send_mail

  def self.perform(user, name_to, mail_to, message, photo )
    puts "Send photo share mail to #{mail_to}"
    UserMailer.sharePhoto(user, name_to, mail_to, message, photo ).deliver
    puts "Sent"
  end

end
