class PhotoUploader < ApplicationUploader
  version :thumb do
    process resize_to_fill: [900, 600]
  end
end
