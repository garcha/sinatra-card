class ImageUploader < CarrierWave::Uploader::Base

  storage :fog

  # Limit possible extensions
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Set the storage directory
  def store_dir
    "images"
  end

  # Versions
  version :thumb do
    process :resize_to_fill => [200,132]
  end

end
