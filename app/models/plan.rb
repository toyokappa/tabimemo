class Plan < ApplicationRecord
  extend Enumerize
  include Redis::Objects

  enumerize :status, in: { draft: 0, published: 1 }, scope: true, predicates: true

  belongs_to :user
  has_many :spots, -> { order(:position) }, inverse_of: :plan, dependent: :destroy
  accepts_nested_attributes_for :spots, reject_if: :all_blank, allow_destroy: true
  has_many :photos, -> { order(:position) }, through: :spots
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :page_views, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }

  scope :default_order, -> { order(published_at: :desc) }
  scope :management_order, -> { reorder(id: :desc) }
  scope :published, -> { with_status(:published).default_order }
  scope :draft, -> { with_status(:draft).default_order }
  scope :with_popular, lambda {
    plan_ids = self.published.pluck(:id)
    likes = Like.between_1_month.except_plan_user.group(:plan_id).count
    comments = Comment.between_1_month.except_plan_user.group(:plan_id).count
    pvs = PageView.between_1_month.group(:plan_id).sum(:count)
    scores = plan_ids.map do |plan_id|
      like = likes[plan_id].to_i
      comment = comments[plan_id].to_i
      pv = pvs[plan_id].to_i + self.pv[plan_id].to_i
      [plan_id, pv > 0 ? (like * 0.7 + comment * 0.3) / pv : 0]
    end
    ids = scores.to_h.delete_if { |_,v| v == 0 }.sort_by { |_,v| -v }.to_h.keys
    self.where(id: ids).order("field(id, #{ids.present? ? ids.join(',') : 'null'})")
  }

  ransack_alias :keyword, :name_or_description_or_spots_name_or_spots_description_or_spots_address

  def get_header_image
    photos.find_by(is_header: true) || photos.first
  end

  # PV機能の実装
  # 方針: PVの厳密な集計はせずにバッチが走ったタイミングで翌日のPVを集計するようにする
  # 1. 投稿したユーザー以外のPVをredisに格納
  # 2. 溜まったPVをDBに保存する処理を実行
  # 3. 保存処理が完了したらredisののPVをリセットする処理の実行
  #
  sorted_set :pv, global: true

  def increment_pv
    self.class.pv.increment(id)
  end

  def daily_pv
    self.class.pv[id].to_i
  end

  def total_pv
    daily_pv + page_views.sum(:count)
  end
end
