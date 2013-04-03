module ApplicationHelper
  include TweetButton

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Snap"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end


  def img_thumb photo
    if !photo.img_size.nil?
      t_width  = photo.img_size.width
      t_height = photo.img_size.height
      height = t_height * Settings.img_thumb_size[:width]/t_width
      height = height > Settings.default_box_size.minsize ? height: Settings.default_box_size.minsize
      {height: height,width: t_width}
    else
      {height: Settings.default_box_size.width, width: Settings.default_box_size.height}
    end
  end
end
