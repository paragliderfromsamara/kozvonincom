module ApplicationHelper
	def is_control?
    request.subdomains.first == 'control'
  end
  
  def cur_locale
     I18n.locale
  end
  
  def oppositeLocale
		
	end
	def sliderPhotos
		if @sliderPhotos != [] && @sliderPhotos != nil
			@sliderPhotos
		else
			Photo.limit(3)
		end
	end
	def my_title
		(@title == nil)? t(:default_site_title) : @title
	end
  def my_header 
    (@header.nil?) ? '' : "<div class = 'row tb-pad-m'><div class = 'small-12 columns' style = 'text-align: center;'><h1>#{@header}</h1></div></div>".html_safe
  end
	def menuItems
		[	
			{
				name: t(:menu_albums),
				link: albums_path
			},
			{
				name: t(:menu_photos),
				link: photos_path
			}
			#{
			#	name: t(:menu_tags),
			#	link: photo_tags_path
			#}#,
			#{
			#	name: t(:menu_photo_tags),
			#	link: photo_tag_references_path
			#}
		]
	end
	def drawMenu
		v = ""
		menuItems.each do |i|
			v += "<li#{" class = 'active'" if current_page?(i[:link])}><a href='#{i[:link]}'>#{i[:name]}</a></li>"
		end
		return v
	end
  
  
  
  def recreate_photo_versions
    Photo.all.each do |p|
      p.link.recreate_versions! if p.link?
    end
  end
end
