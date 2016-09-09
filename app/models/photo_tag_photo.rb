class PhotoTagPhoto < ApplicationRecord
	belongs_to :photo_tag
	belongs_to :photo
	
	
	#after_destroy :clear_unused_tag

	def self.clear_unused_tag
    unused_tags.delete_all
	end
  
	def self.unused_tags
    PhotoTag.where.not(id: PhotoTagPhoto.all.select(:photo_tag_id))
  end

end
