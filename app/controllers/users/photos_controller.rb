class Users::PhotosController < ApplicationController
  def create
    spot = Spot.find(params[:spot_id].to_i)
    photo = spot.photos.build(photo_params)
    if photo.save
      render json: photo, status: :created
    else
      message = photo.errors.full_messages
      render json: message, status: :unprocessable_entity
    end
  end

  private

    def photo_params
      params.require(:photo).permit(:image)
    end
end
