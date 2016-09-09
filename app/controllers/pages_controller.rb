class PagesController < ApplicationController
  def index
  end

  def about
  end
  
  def switch_locale
	  loc = (params[:locale] == "en")? "ru" : "en"
	  redirect_to root_path(locale: loc)
  end


  
end
