class TopsController < ApplicationController

  def index
    store_location

    if signed_in?
      if current_user.following_boxes.count == 0
        @photos=[]
        if params[:category_id].nil? || Category.count < params[:category_id].to_i
          Category.all.each do |c|
            c.boxes.each do |b|
              @photos.concat b.photos
           end
          end
        else
          @category = Category.find(params[:category_id])
          @category.boxes.each do |b|
            @photos.concat b.photos
         end
        end
        @photos = @photos.sort_by{|t| - t.created_at.to_i}
        @photos = @photos.paginate(page: params[:page], per_page: 15)
      else

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
  end

  def about

  end

end
