class User < ApplicationRecord
  attr_accessor :login, :agreement

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :recoverable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable, :omniauthable,
         authentication_keys: [:login]

  has_one :profile, dependent: :destroy, inverse_of: :user
  has_one :notification, dependent: :destroy, inverse_of: :user
  has_many :plans, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_plans, -> { order("likes.created_at desc") }, through: :likes, source: :plan
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :profile

  VALID_NAME_REGEX = /\A[\w+\-]+\z/i
  validates :name, presence: true, length: { maximum: 15 }, uniqueness: { case_sensitive: false }, format: { with: VALID_NAME_REGEX, message: I18n.t("validation.user_name_format") }
  validates :agreement, acceptance: { message: I18n.t("validation.agreement") }

  after_create :init_user

  def from_twitter?
    provider == "twitter"
  end

  class << self
    def find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["name = :value OR lower(email) = lower(:value)", { value: login }]).first
      else
        where(conditions).first
      end
    end

    def find_for_oauth(auth)
      user = User.find_by(uid: auth.uid, provider: auth.provider)
      unless user
        user = User.new(uid: auth.uid, provider: auth.provider, email: auth.info.email, password: Devise.friendly_token[0, 20])
        profile = user.build_profile(name: auth.info.name, description: auth.info.description,
                                     location: auth.info.location, url: auth.info.urls.Website,
                                     remote_image_url: auth.info.image.sub("normal", "400x400"))
      end
      user
    end
  end

  private

    def init_user
      self.create_profile unless self.profile.present?
      self.create_notification
    end
end
