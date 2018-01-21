class Users::PhotosController < ApplicationController
  def create
    spot = Spot.find(params[:spot_id].to_i)
    photo = spot.photos.build(photo_params)
    if photo.save
      render json: { photo: photo, status: "OK" }
    else
      message = photo.errors.full_messages
      render json: { message: message, status: "INVALID" }
    end
  end

  private

    def photo_params
      params.require(:photo).permit(:image)
    end
end
