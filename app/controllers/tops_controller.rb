class TopsController < ApplicationController

  def index
    store_location

    if signed_in?
      if current_user.following_boxes.count == 0
        redirect_to all_path
      end

      # if facebook?(current_user)
        # authentication = current_user.authentications.find_by_provider('facebook')
        # token = authentication.access_token
        # me = FbGraph::User.me(token)
        # friends_id = me.friends.map(&:raw_attributes).map{|f| f['id']}
        # friends_auth = Authentication.where('provider = "facebook" AND uid in (?)', friends_id)
        # @friends_profile = friends_auth.map{|f| f.user if f.user.active?}
      # end

      @photos = current_user.following_photos.paginate(page: params[:page])
    end
  end

  def about

  end

end
