class Photo < ApplicationRecord
	attr_accessor :com_tag_names, :ru_tag_names, :x, :y, :w, :h, :name, :description
	belongs_to :album
	has_many :photo_tag_photos, dependent: :delete_all
	has_many :photo_tags, through: :photo_tag_photos
  has_one :category, through: :album
  after_destroy :clearUnusedTags
	after_save :check_tags_presence
	before_save :makeNewFileName, :split_name_and_description_by_locale
  #before_save :makeNewFileName
	mount_uploader :link, PhotoUploader

  
	def split_name_and_description_by_locale
    #return true if name.blank?
    s = self.split_by_locale(self.name)
    self.com_name = s[:com]
    self.ru_name = s[:ru]
    #return true if description.blank?
    d = self.split_by_locale(self.description)
    self.com_description = d[:com]
    self.ru_description = d[:ru]
  end
  
  def inScobeTags
    ru = com = ''
    photo_tags.each do |t|
      ru += "[#{t.name}]"if t.locale == 'ru'
      com += "[#{t.name}]"if t.locale == 'com'
    end
    return {ru: ru, com: com}
  end
	def check_tags_presence
		if !self.ru_tag_names.blank? || !self.com_tag_names.blank?  
			self.makeTagReferences
		else 
			cleanReferences 
		end
	end
	
	def album_name
		if self.album.nil?
			"Вне альбома"
		else
			self.album.name
		end
	end
	
	def makeTagReferences #должна привязывать новые тэги и отвязывать которых нет
    tRuArr = self.ru_tag_names
    tEnArr = self.com_tag_names
    self.photo_tags.clear
    if !tRuArr.blank?
      self.bindTags('ru', tRuArr)
    end
    if !tEnArr.blank?
      self.bindTags('com', tEnArr)
    end
    clearUnusedTags
	end
  
  def bindTags(locale, str_params)
    arr = str_params.getArrScobes
    if arr.length > 0
      arr.each do |tName|
        self.photo_tags << PhotoTag.new(name: tName, locale: locale).getTagByName
      end
    end
    
  end

	def jsonObj(loc=:ru) 
	{
		id: self.id,
		editPath: "/photos/#{self.id}/edit",
		albumName: self.album.loc_name(loc),
		name: self.loc_name(loc), 
		description: self.description,
		tags: PhotoTag.tags_in_scobes(self.photo_tags),
		original: self.link.url,
		large: self.link.large.url,
		medium: self.link.medium.url,
		small: self.link.small.url,
		sqLarge: self.link.large_sq.url,
		sqMedium: self.link.medium_sq.url,
		sqSmall: self.link.small_sq.url,
		slLarge: self.link.large_slider.url,
		slMedium: self.link.medium_slider.url,
		slSmall: self.link.small_slider.url
	}
	end
	
	def jsonObjString
		"{\"id\": #{self.id}, \"large\": \"#{self.link.large.url}\", \"medium\": \"#{self.link.large.url}\", \"small\": \"#{self.link.large.url}\", \"sqSmall\": \"#{self.link.small_sq.url}\"}"
	end
	
	def cropPhotoForSlider
		large_path = self.link.large_slider
		medium_path = self.link.medium_slider
		small_path = self.link.small_slider
		ph = Magick::ImageList.new(Rails.root.join("public#{self.link}"))
		resized = ph.crop(self.x, self.y, self.w, self.h)
		resized = resized.resize(1200, 300)
		resized.write(Rails.root.join("public#{large_path}"))
		resized = resized.resize(1000, 250)
		resized.write(Rails.root.join("public#{medium_path}"))
		resized = resized.resize(640, 160)
		resized.write(Rails.root.join("public#{small_path}"))
	end
  

private 
	def makeNewFileName
		self.file_name = SecureRandom.hex(7) if new_record?
	end
	
  def clearUnusedTags
    PhotoTagPhoto.clear_unused_tag
  end
  
	def cleanReferences
		if !self.photo_tag_photos.blank?
			self.photo_tag_photos.clear
		end
	end
	
end
