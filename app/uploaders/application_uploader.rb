class ApplicationUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    if Rails.env.production?
      "uploads/cache/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "tmp/cache/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  def extension_whitelist
    %w[jpg jpeg gif png]
  end

  process convert: "jpg"

  def filename
    "#{secure_token}.jpg" if original_filename.present?
  end

  protected

    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
    end
end
