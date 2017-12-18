class Spot < ApplicationRecord
  has_many :photos, inverse_of: :spot, dependent: :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true

  belongs_to :plan

  validates :name, length: { maximum: 50 }
  validates :description, length: { maximum: 1000 }

  before_save :set_default_name_with_blank

  def create_photos_by(photo_params)
    Photo.transaction do
      photo_params.each do |index|
        next if photo_params[index][:_destroy] == true
        photo_params[index][:photos]&.each do |photo|
          next unless id == photo_params[index][:id].to_i
          return unless photos.create(image: photo)
        end
      end
    end
  end

  private

    def set_default_name_with_blank
      self.name = I18n.t("form.no_spot_name") if name.blank?
    end
end
