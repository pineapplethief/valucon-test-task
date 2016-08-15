class BaseUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  storage :file

  process :set_content_type

  with_options if: :image? do
    process :validate_dimensions
    process :strip
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def image?(new_file = file)
    return false if file.blank?
    new_file.content_type.start_with? 'image'
  end

end
