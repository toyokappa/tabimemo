class Trophy < ApplicationRecord
  belongs_to :user

  class << self
    def titles
      column_names - %w[id user_id created_at updated_at]
    end
  end

  # プラン数の実績 ---------
  def judge_plan_count!
    case user.plans.published.count
    when 10
      return if plan_count_lv1?

      update!(plan_count_lv1: true)
    when 30
      return if plan_count_lv2?

      update!(plan_count_lv2: true)
    when 50
      return if plan_count_lv3?

      update!(plan_count_lv3: true)
    when 100
      return if plan_count_lv4?

      update!(plan_count_lv4: true)
    end
  end

  # PV数の実績 ---------
  def judge_pv_count!
    case user.plan_page_views.sum(&:count)
    when 1_000
      return if pv_count_lv1?

      update!(pv_count_lv1: true)
    when 10_000
      return if pv_count_lv2?

      update!(pv_count_lv2: true)
    when 100_000
      return if pv_count_lv3?

      update!(pv_count_lv3: true)
    when 1_000_000
      return if pv_count_lv4?

      update!(pv_count_lv4: true)
    end
  end

  # いいね数の実績 ---------
  def judge_like_count!
    case user.plan_likes.except_plan_user.count
    when 50
      return if like_count_lv1?

      update!(like_count_lv1: true)
    when 100
      return if like_count_lv2?

      update!(like_count_lv2: true)
    when 1_000
      return if like_count_lv3?

      update!(like_count_lv3: true)
    when 5_000
      return if like_count_lv4?

      update!(like_count_lv4: true)
    end
  end

  # コメント数の実績 ---------
  def judge_comment_count!
    case user.plan_comments.except_plan_user.count
    when 10
      return if comment_count_lv1?

      update!(comment_count_lv1: true)
    when 50
      return if comment_count_lv2?

      update!(comment_count_lv2: true)
    when 100
      return if comment_count_lv3?

      update!(comment_count_lv3: true)
    when 500
      return if comment_count_lv4?

      update!(comment_count_lv4: true)
    end
  end
end
