class Jobs::SendVerifyMail
  @queue = :send_mail

  def self.perform(user)
    puts "Send verify mail to #{user["email"]}"
    UserMailer.verify(user).deliver
    puts "Sent"
  end

end
