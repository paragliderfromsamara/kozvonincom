class PhotoTag < ApplicationRecord
	has_many :photo_tag_photos
	has_many :photos, through: :photo_tag_photos, dependent: :destroy
	validate :uniqNameCheck
	
	before_save :name_to_downcase
	
	def name_to_downcase
		if self.name.present?
			self.name = self.name.mb_chars.downcase
		end
	end
	
	def uniqNameCheck
		tag = PhotoTag.find_by(name: self.name, locale: self.locale)
		if !tag.nil?
			errors.add(:name, "Тэг уже существует") if tag != self
		end
	end
	
	def photos
		Photo.where(id: self.photo_tag_references.select(:photo_id))
	end
	
	def getTagByName #ищет тэг если такой есть, если нет создает и возвращает найденный или новый тэг
		self.name = self.name.mb_chars.downcase
		tag = PhotoTag.find_by(name: self.name, locale: self.locale)
		if tag.nil?
			tag = self if self.save
		end
		return tag
	end
  
  def self.select_by_locale(loc = 'ru')
    where(locale: loc).order("name ASC")
  end
  
  def self.tags_in_scobes(tags)
    v = ''
    tags.each do |t|
      v += "[#{t[:name]}]"
    end
    return v
  end
end
