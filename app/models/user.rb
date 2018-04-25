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
  has_many :social_accounts, dependent: :destroy

  accepts_nested_attributes_for :profile
  accepts_nested_attributes_for :social_accounts

  VALID_NAME_REGEX = /\A[\w+\-]+\z/i
  validates :name, presence: true, length: { maximum: 15 }, uniqueness: { case_sensitive: false }, format: { with: VALID_NAME_REGEX, message: I18n.t("validation.user_name_format") }
  validates :agreement, acceptance: { message: I18n.t("validation.agreement") }

  after_create :init_user

  def from_social_accounts?
    social_accounts.present?
  end

  def social_account_with(sns)
    social_accounts.find_by(provider: sns.to_s)
  end

  def password_required?
    super && (social_accounts.blank? || persisted?)
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
      user = SocialAccount.find_by(uid: auth.uid, provider: auth.provider)&.user
      unless user
        user = self.new(email: auth.info.email)
        user.social_accounts.build(uid: auth.uid, provider: auth.provider)
        user.build_profile(name: auth.info.name, description: auth.info.description,
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
