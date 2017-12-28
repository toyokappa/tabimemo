class User < ApplicationRecord
  attr_accessor :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :recoverable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         authentication_keys: [:login]

  has_one :profile, dependent: :destroy, foreign_key: "id"
  has_many :plans, dependent: :destroy

  VALID_NAME_REGEX = /\A[\w+\-]+\z/i
  validates :name, presence: true, length: { maximum: 15 }, uniqueness: { case_sensitive: false }, format: { with: VALID_NAME_REGEX }

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["name = :value OR lower(email) = lower(:value)", { value: login }]).first
    else
      where(conditions).first
    end
  end
end
