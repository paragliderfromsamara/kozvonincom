module FiltersHelper
  def photo_filter
    cats = filter_categories
    tags = filter_tags
    val = "
    <div id = 'filter-menu' style = 'display: none;' locale = \"#{cur_locale}\">
        <div class = 'row tb-pad-m'>
            <div class = 'small-12 medium-6 columns'>
                <h5>
                    #{t(:menu_categories)}
                </h5>
                 #{cats}
                <h5>
                    #{t(:selected_tags)}
                </h5>
                <div id = 'selected-tags-field'>
                    <p id = 'empty-tag-list-msg' style = 'display: #{tags[:tags_selected].blank? ? "block" : 'none'}'>#{t(:empty_sel_tag_list_msg)}</p>
                    #{tags[:tags_selected]}
                </div>
                <a id = 'apply-filter-but' class = 'button primary'>
                    #{t(:complete_filter_but_text)}
                </a>
                <a id = 'reset-filter-but' class = 'button secondary'>
                    #{t(:reset_filter_but_text)}
                </a>
            </div>
            <div class = 'small-12 medium-6 columns'>
                <h5>
                    #{t(:tags_list)}
                </h5>
                <div id = \"tags-list-field\">
                    #{tags[:tags_list]}
                </div>
                
            </div>
        </div>
        </div>
    </div>
    "
    return val.html_safe
  end

  private
  def filter_tags
		sTags = session[:filter_tags].nil? ? [] : session[:filter_tags]
    tags = PhotoTag.select_by_locale(cur_locale)
    prevChar = ""
		tabs = ""
		tabsContent = ""
		tempContent = ''
    tags_selected = ''
		if !tags.blank?
			i = 0
			tags.each do |n| 
        is_selected = !sTags.index(n.id.to_s).nil?
				curName = n.name.first
				if curName != prevChar
					tabsContent += "<div class='tabs-panel#{' is-active' if (i==1 && params[:panel] == nil) || i == params[:panel].to_i}' id='panel#{i}v'><ul id = 'tagsList' data-tabs>#{tempContent}</ul></div>" if i > 0
					i += 1
					tempContent = ""
					prevChar = curName
					tabs += "<li class='tabs-title#{' is-active' if (i==1 && params[:panel] == nil) || i == params[:panel].to_i}'><a href='#panel#{i}v'>#{curName.mb_chars.upcase}</a></li>"
				end
        tags_selected += "<li><span> #{n.name} <a tag-id='#{n.id}'><i class=\"fi-x fi-medium\"></i></a></span></li>" if is_selected
				tempContent += "<a class = 'filter-select-tag#{" selected" if is_selected}' tag-id=#{n.id}><li><p>#{"<span class = 'badge success'><i class = 'fi-check'></i></span>" if is_selected} #{n.name}</p></li></a>"
				tabsContent += "<div class='tabs-panel#{' is-active' if (i==1 && params[:panel] == nil) || i == params[:panel].to_i}' id='panel#{i}v'><ul id = 'tagsList' data-tabs>#{tempContent}</ul></div>" if n == tags.last
			end
		end
		return {tags_selected: "<ul>#{tags_selected}</ul>",tags_list: "<ul class=\"tabs\" data-tabs id = \"charListTabs\">#{tabs}</ul><div class=\"tabs-content\" data-tabs-content=\"charListTabs\">#{tabsContent}</div>"}
    
  end
  def filter_categories
    cats = session[:filter_categories].nil? ? [] : session[:filter_categories]
    categories = @categories.nil? ? Category.enabled : @categories
    val = ""
    categories.each do |c|
      if !cats.index(c.id.to_s).nil?
        val += "<a class = 'category-filter-item selected' category-id = '#{c.id}'>
                        <li>
                            <span class = 'badge success'><i class = 'fi-check'></i></span> #{c.text(cur_locale)[:name]}
                        </li>
                </a>"
      else
        val += "<a class = 'category-filter-item' category-id = '#{c.id}'>
                        <li>
                            <span class = 'badge primary'><i class = 'fi-plus'></i></span> #{c.text(cur_locale)[:name]}
                        </li>
                </a>"
      end
    end
    return "<ul id = 'categoryList'>#{val}</ul>"
  end
end
