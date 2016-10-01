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
				name: t(:menu_categories),
				#link: categories_path,
                dropdown: cat_dd_list
			}
			#{
			#	name: t(:menu_photos),
			#	link: photos_path
			#}
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
			v += "<li #{" class = 'active'" if current_page?(i[:link]) && !i[:link].nil?}>"
            v += "<a href='#{i[:link].nil? ? '#' : i[:link]}'>#{i[:name]}</a>"
            v += i[:dropdown] if !i[:dropdown].blank?
            v += "</li>"
		end
		return v
	end
    def cat_dd_list
        html = ''
        cats = Category.enabled
        cats.each {|c| html += "<li#{" class = 'active'" if current_page?(category_path(c))}><a href = '#{category_path(c)}'>#{c.loc_name(cur_locale)}</a></li>"} 
        html = html.blank? ? "" : "<ul class = 'menu vertical'>#{html}</ul>"
        return html
    end
  
  
  def recreate_photo_versions
    Photo.all.each do |p|
      p.link.recreate_versions! if p.link?
    end
  end
end
