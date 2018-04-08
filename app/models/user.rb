class User < ApplicationRecord
  attr_accessor :login, :agreement

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :recoverable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         authentication_keys: [:login]

  has_one :profile, dependent: :destroy, foreign_key: "id", inverse_of: :user
  has_one :notification, dependent: :destroy, inverse_of: :user
  has_many :plans, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_plans, -> { order("likes.created_at desc") }, through: :likes, source: :plan
  has_many :comments, dependent: :destroy

  VALID_NAME_REGEX = /\A[\w+\-]+\z/i
  validates :name, presence: true, length: { maximum: 15 }, uniqueness: { case_sensitive: false }, format: { with: VALID_NAME_REGEX, message: I18n.t("validation.user_name_format") }
  validates :agreement, acceptance: { message: I18n.t("validation.agreement") }

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["name = :value OR lower(email) = lower(:value)", { value: login }]).first
    else
      where(conditions).first
    end
  end
end
