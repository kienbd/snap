class UsersController < ApplicationController
  include SessionsHelper

  before_filter :signed_in_user, only: [:index,:edit,:update,:destroy, :following, :followers]
  before_filter :correct_user, only: [:edit,:update]
  before_filter :admin_user, only: :destroy
  before_filter :create_user, only: [:create,:new]
  before_filter :auth_user, only: [:new]

  def index
    @allusers = User.all
    @users = User.paginate(page: params[:page])
  end

  def show
    store_location
    if params[:id].nil?
      @user = User.find_by_name(params[:username])
    else
      @user = User.find_by_id(params[:id])
    end
    @boxes = @user.boxes
    respond_to do |format|
      format.html
      format.js
    end
  end

  def send_invite
    UserMailer.invite(params[:email]).deliver
    redirect_to root_path
  end

  def followers
    @user = User.find(params[:id])
    @followers = @user.followers
    respond_to do |format|
      format.html
      format.js
    end
  end


  def following
    @user = User.find(params[:id])
    @following = @user.following_users
    respond_to do |format|
      format.html
      format.js
    end
  end

  def photos
    store_location
    @user = User.find(params[:id])
    @photos = @user.photos.paginate(page: params[:page],per_page: 15)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def likedphotos
    @user = User.find(params[:id])
    @photos = @user.liked_photos.paginate(page: params[:page],per_page: 15)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def find_facebook_friends
    @user = User.find(params[:id])
    if @friends = fbfriends_in_pon_not_connect(@user)
      respond_to do |format|
        format.html
        format.js
      end
    else
      # not connect with facebook
      # do something
    end
  end

  def new
    auth = session[:omniauth]
    authentication = session[:authentication]
    @user = User.new
    (@user.authentications << authentication; session.delete :authentication) if authentication
    if auth
      @user.remote_avatar_url = auth["info"]["image"].gsub!('square','large')
      @user.name = auth["info"]["name"]
      @user.email = auth["info"]["email"]
      session.delete :omniauth
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      if @user.authentications.empty?
        deliver_verification_instructions(@user)
        flash[:notice] = "Thanks for signing up, we've delivered an email to you with instructions on how to complete your registration!"
      else
        @user.verify!
        sign_in @user
      end
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    store_location
    @user = User.find(params[:id])
    @current_user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      respond_to do |format|
        format.html {
          sign_in @user
          redirect_to @user
        }
        format.js
      end
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end

  def toggle_active
    if current_user.active
      current_user.update_attribute("active",false)
    else
      current_user.update_attribute("active",true)
    end
    sign_in current_user
    redirect_to edit_user_path(current_user)
  end

  def admin_page

  end

  private

  def auth_user
    authentication = session[:authentication]
    @user = User.new
    if authentication
      token = authentication.access_token
      token_secret = authentication.token_secret
      if authentication.provider == 'facebook'
        client = FBGraph::Client.new(:client_id => GRAPH_APP_ID, :secret_id => GRAPH_SECRET, :token => token)
        user = client.selection.me
        name = user.info!.name
        email = user.info!.email
      else
        Twitter.configure do |config|
          config.consumer_key = TWITTER_APP_ID
          config.consumer_secret = TWITTER_SECRET
          config.oauth_token = token
          config.oauth_token_secret = token_secret
        end
        name = Twitter.user.name
        email = ""
      end
      @user = User.new(:name => name, :email => email)
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def create_user
    if signed_in?
      redirect_to(root_path)
    end
  end
end
