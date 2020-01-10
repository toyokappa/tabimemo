class PhotoUploader < ApplicationUploader
  version :thumb do
    process resize_to_limit: [1000, 1000]
  end
end
