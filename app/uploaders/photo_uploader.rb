class PhotoUploader < ApplicationUploader
  process resize_to_limit: [1000, 1000]

  version :thumb do
    process resize_to_fill: [600, 400]
  end
end
