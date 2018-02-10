class Plan < ApplicationRecord
  extend Enumerize
  include Redis::Objects

  enumerize :status, in: { draft: 0, published: 1 }, scope: true, predicates: true

  @@yesterday = "pv#{Date.yesterday.strftime('%Y_%m_%d')}"
  @@today = "pv#{Date.today.strftime('%Y_%m_%d')}"
  # 日付別でDBに保存するようのPV
  sorted_set @@yesterday, global: true
  sorted_set @@today, global: true
  # 画面表示用のPV
  sorted_set :display_pv, global: true

  def increment_pv
    set_pv_keys
    self.class.send(@@today).increment(id)
    self.class.display_pv.increment(id)
  end

  def show_pv
    set_pv_keys
    self.class.display_pv[id].to_i
  end

  belongs_to :user
  has_many :spots, -> { order(:position) }, inverse_of: :plan, dependent: :destroy
  accepts_nested_attributes_for :spots, reject_if: :all_blank, allow_destroy: true
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :page_views, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 1000 }

  scope :default_order, -> { order(id: :desc) }
  scope :published, -> { with_status(:published).default_order }
  scope :draft, -> { with_status(:draft).default_order }

  private

    def set_pv_keys
      if @@today != "pv#{Date.today.strftime('%Y_%m_%d')}"
        @@yesterday = "pv#{Date.yesterday.strftime('%Y_%m_%d')}"
        @@today = "pv#{Date.today.strftime('%Y_%m_%d')}"
      end
    end
end
