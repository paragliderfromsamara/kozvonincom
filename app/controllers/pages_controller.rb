class PagesController < ApplicationController
  def index
      @slider_photos = Photo.where(is_album_photo: true)
  end

  def about
  end
  
  def switch_locale
	  loc = (params[:locale] == "en")? "ru" : "en"
	  redirect_to root_path(locale: loc)
  end

  def please_wait
      render layout: false
  end
  def err_404
      @title = t(:page_not_found) + "(404)"
      @header = "#{t :page_not_found }"
  end
  
end
