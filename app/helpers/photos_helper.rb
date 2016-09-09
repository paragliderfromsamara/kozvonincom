module PhotosHelper
  def listing_photos_json
    v = []
    @photos.each do |p|
      v += [p.jsonObj(params[:locale])]
    end
  end
  
  def getFilterPhotos(t_ids, c_ids)
    tags_phs_ids = PhotoTagPhoto.where(photo_tag_id: t_ids).select(:photo_id).distinct
    photos = []
    if c_ids.length > 0 
      cats = Category.where(id: c_ids)
      if t_ids.length > 0
        cats.each do |c|
          photos += c.photos.where(id: tags_phs_ids)
        end
      else 
        cats.each do |c|
          photos += c.photos
        end
      end
    else
      photos = Photo.where(id: tags_phs_ids)
    end
    return photos 
  end
  
	def photo_pagination 
		cur_index = @idx #@photos.index(@photo) #Текущий элемент
		phsCount = @photos.size #Номер последнего элемента
		max_number_in_line = 7 #Максимальное количесво номеров в ряд (ДОЛЖНО БЫТЬ НЕЧЁТНЫМ!!!)
		val = ''
		@f='none'
		@l='none'
		@c='none'
		offset = (max_number_in_line-1)/2
		if phsCount < max_number_in_line
			i = 0
			@photos.each do |p|
				if i == cur_index
					val += "<a href = '#{photo_path(photo_link_params(i))}'><div class = 'ph-paginate ph-cur' style = 'background-image:url(\"#{p.link.small_sq}\");' ></div></a>"
				else
					val += "<a href = '#{photo_path(photo_link_params(i))}'><div class='ph-paginate' style = 'background-image:url(\"#{p.link.small_sq}\");'></div></a>"
				end
				i += 1	
			end
		else
			fVisible = 0
			lVisible = 0
			if (cur_index + offset) > (phsCount-1)
				fVisible = phsCount-max_number_in_line
				lVisible = phsCount-1
			elsif(cur_index - offset) < 0
				fVisible = 0
				lVisible = max_number_in_line-1
			elsif !((cur_index + offset) > (phsCount-1)) && !((cur_index - offset) < 0)
				fVisible = cur_index - offset
				lVisible = cur_index + offset
			end
			@f=fVisible
			@l=lVisible
			@c= cur_index
			i = 0
			@photos.each do |p|
				if i == cur_index
					val += "<a href = '#{photo_path(photo_link_params(i))}'><div class = 'ph-paginate ph-cur' style = 'background-image:url(\"#{p.link.small_sq}\");' ></div></a>"
				elsif !(i<fVisible) and !(i>lVisible) 
					val += "<a href = '#{photo_path(photo_link_params(i))}'><div class='ph-paginate' style = 'background-image:url(\"#{p.link.small_sq}\");'></div></a>"
				else
					val += "<a href = '#{photo_path(photo_link_params(i))}'><div class='ph-paginate ph-h' style = 'background-image:url(\"#{p.link.small_sq}\");'></div></a>"
				end
				i+=1
			end
		end
		return "#{val}"
	end
  
  def photo_prev
    prv = @idx - 1
    if prv >= 0
      return "<a id = 'prev-photo-link' href = '#{photo_path(photo_link_params(prv))}' title='#{t('.prev')}'><div class = 'arrows' id = 'arrow-left'></div></a>"
    else 
      return ''
    end
  end
  def photo_next
    nxt = @idx + 1
    if nxt < @photos.length
      return "<a id = 'next-photo-link' href = '#{photo_path(photo_link_params(nxt))}' title='#{t('.next')}'><div class = 'arrows' id = 'arrow-right'></div></a>"
    else
      return ''
    end
  end
  
  def photo_link_params(idx)
    prms = {}
    prms[:id] = @photos[idx].id
    prms[:tags] = params[:tags] if !params[:tags].blank?
    prms[:categories] = params[:categories] if !params[:categories].blank?
    prms[:index] = idx
    return prms
  end
end
