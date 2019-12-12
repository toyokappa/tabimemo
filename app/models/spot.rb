class Spot < ApplicationRecord
  has_many :photos, -> { order(:position) }, inverse_of: :spot, dependent: :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true

  belongs_to :plan

  validates :name, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }

  before_save :set_default_name_with_blank

  private

    def set_default_name_with_blank
      self.name = I18n.t("form.no_spot_name") if name.blank?
    end
end
