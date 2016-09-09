class Category < ApplicationRecord
  has_many :albums, dependent: :destroy 
  has_many :photos, through: :albums
  
  validates :ru_name, presence: {message: "Поле название на русском языке не должно быть пустым"}, uniqueness: {message: "Такое название на русском уже есть"}
  validates :com_name, presence: {message: "Поле название на английском языке не должно быть пустым"}, uniqueness: {message: "Такое название на английском уже есть"}
  
  def enabled_photos
    photos.where(is_category_photo: true)
  end
  
  def enabled_albums
    albums.where(is_draft: false, is_enable: true).order("get_at ASC")
  end
  
  def text(loc = :ru)
    (loc == :com) ? {name: com_name, description: com_description} : {name: ru_name, description: ru_description}
  end
  
  def self.enabled
    where(is_enable: true).order("order_number ASC")
  end
end
