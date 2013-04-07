class CategoriesController < ApplicationController

  before_filter :signed_in_user

  def index
    store_location
    @photos= Photo.order("created_at desc").all
    @photos = @photos.paginate(page: params[:page], per_page: 15)
  end

  def show
    @category = Category.find(params[:id]) || Category.find(params[:name])
    if @category
      @photos = @category.photos.paginate(page: params[:page], per_page: 15)
    else
      redirect_to categories_path
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

end
