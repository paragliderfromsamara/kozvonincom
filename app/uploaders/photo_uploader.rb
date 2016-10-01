#encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  #include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end
	
	version :largest do
		process :resize_to_fit => [1600, 1200]
	end
  
	version :background, from_version: :largest do
		process :resize_to_fill => [1600, 800]
	end
  
	version :kra_block, from_version: :largest do
		process :resize_to_fill => [200, 133]
	end
  
	version :large, from_version: :largest do
        
		process :resize_to_fit => [1000, 750]
        
	end
	version :meta_com, from_version: :large do
        process :add_water_mark_com
        process :resize_to_fit => [600, 450]
    end
	version :meta_ru, from_version: :large do
        process :add_water_mark_ru
        process :resize_to_fit => [600, 450]
    end
	version :medium do
		process :resize_to_fit => [600, 450]
	end

	version :small do
		process :resize_to_fit => [300, 225]
	end
  
	version :large_slider do
		process :resize_to_fill => [1200, 300]
	end
	
	version :medium_slider do
		process :resize_to_fill => [1000, 250]
	end
	
	version :small_slider do
		process :resize_to_fill => [640, 160]
	end
	
	version :large_sq do
		process :resize_to_fill => [400, 400]
	end
	
	version :medium_sq do
		process :resize_to_fill => [200, 200]
	end
	
	version :small_sq do
		process :resize_to_fill => [100, 100]
	end
  
  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{model.file_name}.jpg" if original_filename
  end

  private 
  
  def add_water_mark_com
      manipulate! do |image|
          mark = Magick::Image.new(300, 18){self.background_color = 'white' 
                                            self.quality= 100}
          gc = Magick::Draw.new
          gc.text_antialias(true)
          gc.gravity = Magick::CenterGravity
          gc.pointsize = 14
          gc.fill = 'black'
          gc.font = "Ubuntu"
          gc.font_weight = Magick::NormalWeight
          gc.stroke = 'none'
          gc.annotate(mark, 0, 0, 0, 3, "Roman Kozvonin | KOZVONIN.COM")
          #mark.shade(true, 310, 30)
          #mark = Magick::Image.read(Rails.root.join("public/water_marks/en_mark.jpg")).first
          image.composite!(mark, Magick::SouthGravity, Magick::OverCompositeOp)
      end
  end
  def add_water_mark_ru
      manipulate! do |image|
          mark = Magick::Image.new(300, 18){self.background_color = 'white' 
                                            self.quality= 100}
          gc = Magick::Draw.new
          gc.text_antialias(true)
          gc.gravity = Magick::CenterGravity
          gc.pointsize = 14
          gc.fill = 'black'
          gc.font = "Ubuntu"
          gc.font_weight = Magick::NormalWeight
          gc.stroke = 'none'
          gc.annotate(mark, 0, 0, 0, 3, "Роман Козвонин | KOZVONIN.RU")
          #mark.shade(true, 310, 30)
          #mark = Magick::Image.read(Rails.root.join("public/water_marks/en_mark.jpg")).first
          image.composite!(mark, Magick::SouthGravity, Magick::OverCompositeOp)
      end
  end
end
