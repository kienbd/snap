module Facebook

  def fbfriends_in_pon_not_connect user
    facebook = user.authentications.find_by_provider('facebook')
    if facebook
      me = FbGraph::User.me (facebook.access_token)

      fb_friends_uid = me.friends.map(&:identifier)

      # all facebook user in Pon
      pon_users_uid = User.joins(:authentications).where("users.id != ?", user.id).select("authentications.uid").map(&:uid)
      # friends in Pon
      friends_uid = user.following_users.joins(:authentications).select("authentications.uid").map(&:uid)

      # friend in facebook but not friend in Pon
      not_friends_uid = fb_friends_uid & (pon_users_uid - friends_uid)

      User.joins(:authentications).where("authentications.uid in (?)", not_friends_uid)
    else
      return false
    end
  end

  def facebook_friends(user)
    invite_friends = []
    if user && facebook = user.authentications.find_by_provider('facebook')
      me = FbGraph::User.me facebook.access_token

      friends = me.friends
      friends.each do |friend|
        authentication = Authentication.where("provider = ? and uid = ?",'facebook',friend.identifier)
        if authentication.empty?
          invite_friends << friend
        end
      end
      invite_friends
    else
      invite_friends = nil
    end
  end

end
