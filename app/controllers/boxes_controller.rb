class BoxesController < ApplicationController

  def index
    @user=current_user
    @boxes=@user.boxes.all
  end

  def create
    if !params[:box][:title].nil? && params[:box][:title] != ""
      title = params[:box][:title]
      if !params[:box][:category_id].nil?
        @box = current_user.boxes.build(title: title, category_id: params[:box][:category_id])
      else
        @box = current_user.boxes.build(title: title, category_id: 32)
      end

      @user = current_user
      if @box.save
        follower_follow_this_box(@box)
        respond_to do |format|
          format.html {redirect_back_or user_path(current_user)}
          format.js
        end
      else
        redirect_back_or user_path(current_user)
      end
    else
      flash[:error] = "Title field is empty"
      redirect_back_or user_path(current_user)
    end
  end

  def show
    @box=Box.find(params[:id])
    @user = @box.owner
    @photos = @box.photos.order("created_at DESC").paginate(page: params[:page],per_page: 15)
  end

  def followers
    @followers = Box.find(params[:id]).users
    if @followers == nil
    end
  end

  def destroy
    # User.find(params[:id]).destroy
    box = Box.find(params[:id])
    user = box.owner
    box.destroy
    delete_rel_to_box(box)
    flash[:success] = "Box #{params[:id]} destroyed."
    redirect_to user_path(user)
  end

  def delete
  end

  def edit
    @box = Box.find(params[:id])
  end

  def update
    @box = Box.find(params[:id])
    if @box.update_attributes(params[:box])
      flash[:success] = "Box info updated"
      redirect_to box_path(@box)
    else
      render 'edit'
    end
  end


  private
  def follower_follow_this_box(box)
    followers = current_user.followers
    if followers != nil
      followers.each do |follower|
        follower.follow_box!(box)
      end
    end
  end

  def delete_rel_to_box(box)
    rel = UserBoxFollow.find_by_box_id(box.id)
    if rel != nil
      rel.destroy
    end
  end
end
