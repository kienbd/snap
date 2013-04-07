class SharesController < ApplicationController

  def new_share_photo_via_email
    @photo = Photo.find(params[:photo_id])
    respond_to do |format|
      format.js
    end
  end

  def share_photo_via_email
    mail_to = params[:email]
    name_to = params[:name_to]
    message = params[:message]
    photo = Photo.find(params[:photo_id])
    Resque.enqueue(Jobs::SendPhotoShareMail, current_user, name_to, mail_to, message, photo)
    # mail = UserMailer.sharePhoto(current_user.name, name_to, mail_to, message, photo )
    # mail.deliver

    respond_to do |format|
      format.js
    end
  end

end
