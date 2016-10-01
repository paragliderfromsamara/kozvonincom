module PhotoTagsHelper
	def photoTagTabs
		tags = @photo_tags.nil? ? PhotoTag.select_by_locale(cur_locale) : @photo_tags
    prevChar = ""
		tabs = ""
		tabsContent = ""
		tempContent = ''
		if !tags.blank?
			i = 0
			@curTag = tags.first if @curTag.nil?
			tags.each do |n| 
				curName = n.name.first
				if curName != prevChar
					tabsContent += "<div class='tabs-panel#{' is-active' if (i==1 && params[:panel] == nil) || i == params[:panel].to_i}' id='panel#{i}v'><ul id = 'tagsList' data-tabs>#{tempContent}</ul></div>" if i > 0
					i += 1
					tempContent = ""
					prevChar = curName
					tabs += "<li class='tabs-title#{' is-active' if (i==1 && params[:panel] == nil) || i == params[:panel].to_i}'><a href='#panel#{i}v'>#{curName.mb_chars.upcase}</a></li>"
				end
				tempContent += "<a class = 'filter-select-tag' tag-id=#{n.id}><li#{' class = "is-active"' if n == @curTag}><p>#{n.name}</p></li></a>"
				tabsContent += "<div class='tabs-panel#{' is-active' if (i==1 && params[:panel] == nil) || i == params[:panel].to_i}' id='panel#{i}v'><ul id = 'tagsList' data-tabs>#{tempContent}</ul></div>" if n == tags.last
			end
		end
		return "<ul class=\"tabs\" data-tabs id = \"charListTabs\">#{tabs}</ul><div class=\"tabs-content\" data-tabs-content=\"charListTabs\">#{tabsContent}</div>"
	end
  
  def tags_list_on_photo(photo=@photo)  
    tags = photo.photo_tags.where(locale: cur_locale.to_s)
    return "<p>#{t('.empty_tag_list')}</p>" if tags.size == 0 && controller.controller_name == 'photos'
    v = ''
    tags.each {|tag| v += "<li><a class= 'filter-tag-in-list' tag-id = \"#{tag.id}\"><i class = 'fi-price-tag'></i> #{tag.name}</a></li>"}
    return "<ul id = 'photo-show-tag-list'>#{v}</ul>"
  end
end
