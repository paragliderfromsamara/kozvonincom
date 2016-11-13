class Album < ApplicationRecord
	attr_accessor :uploaded_photos, :name, :content
  #attr_accessible :name, :category_id, :name, :is_draft, :is_enable
  belongs_to :category
	has_many :photos, dependent: :destroy
	before_save :set_status
  after_validation :split_name_and_content_by_locale
	after_create :bind_photos
	
	
	validates :name, presence: {message: "Поле название не должно быть пустым"}, if: :is_not_draft?
        
    def main_photo
        p = self.photos.find_by(is_album_photo: true)
        if p.nil?
            return self.photos.first
        else
            return p
        end
    end
  
  def is_not_draft?
    !self.is_draft
  end 
  
  def self.get_draft
    d = Album.find_by(is_draft: true)
    d = d.nil? ? Album.create(category_id: Category.first.id, is_draft: true, is_enable: false) : d
    return d
  end 
  
  
  def split_name_and_content_by_locale
    return true if is_draft
    n = self.split_by_locale(self.name)
    c = self.split_by_locale(self.content)
    self.com_name = n[:com]
    self.ru_name = n[:ru]
    self.com_content = c[:com]
    self.ru_content = c[:ru]
    
  end
	def set_status
		self.is_enable = get_status		
	end
	def get_status
		(self.is_enable == nil)? false : self.is_enable
	end
	def status
    if is_enable && !is_draft
      "Активен"
    elsif !is_enable && !is_draft
      "Не активен"
    else
      "Черновик"
    end 
	end
  
	def bind_photos
    return true if is_draft
		phs = Photo.where(album_id: [nil, 0])
		if phs.count > 0
			phs.each {|p| p.update_attribute(:album_id, self.id)}
		end
	end
	
  def uploaded_photos=(attrs)
	attrs.each {|attr| self.photos.build(:link => attr)}
  end
end
