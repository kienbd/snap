class CommentsController < ApplicationController

  before_filter :signed_in_user
  before_filter :admin_user, only: :destroy
  before_filter :correct_user, only: [:edit,:update]

  def new
  end

  def create
    @comment = Comment.new(params[:comment])
    if @comment.save
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js { render 'create_error' }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js { render 'update_error' }
      end
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    photo = comment.photo
    if comment.destroy
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js { render 'destroy_error' }
      end
    end
  end

end
