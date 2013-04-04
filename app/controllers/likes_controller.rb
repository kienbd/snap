class LikesController < ApplicationController

	def create
		photo_id = params[:like][:photo_id]

		@photo = Photo.find(photo_id)
		if !@photo.nil? && !current_user.liked_photo?(@photo)
			current_user.like(@photo)
			respond_to do |format|
				format.html { redirect_to @photo }
				format.js
			end

		end

	end

	def destroy

		@photo = Like.find(params[:id]).photo
		current_user.unlike(@photo)
		respond_to do |format|
			format.html { redirect_to @photo }
			format.js
		end

	end

end
