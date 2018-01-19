class Users::PhotosController < ApplicationController
  def create
    spot = Spot.find(params[:spot_id].to_i)
    if photos = spot.create_photos_by(photo_params)
      render json: photos
    end
  end

  private

    def photo_params
      params.require(:photo).permit(images: [])
    end
end
