class Trophy < ApplicationRecord
  include Trophy::Configurable

  belongs_to :user

  class << self
    def titles
      column_names - %w[id user_id created_at updated_at]
    end
  end

  def exp
    total = 0
    Trophy.titles.each do |title|
      total += Trophy.const_get("#{title.upcase}_EXP") if send(title)
    end
    total
  end

  # プラン数の実績 ---------
  def judge_plan_count!
    case user.plans.published.count
    when PLAN_COUNT_LV1_THRESHOLD
      return if plan_count_lv1?

      update!(plan_count_lv1: true)
    when PLAN_COUNT_LV2_THRESHOLD
      return if plan_count_lv2?

      update!(plan_count_lv2: true)
    when PLAN_COUNT_LV3_THRESHOLD
      return if plan_count_lv3?

      update!(plan_count_lv3: true)
    when PLAN_COUNT_LV4_THRESHOLD
      return if plan_count_lv4?

      update!(plan_count_lv4: true)
    end
  end

  # PV数の実績 ---------
  def judge_pv_count!
    case user.plan_page_views.sum(&:count)
    when PV_COUNT_LV1_THRESHOLD
      return if pv_count_lv1?

      update!(pv_count_lv1: true)
    when PV_COUNT_LV2_THRESHOLD
      return if pv_count_lv2?

      update!(pv_count_lv2: true)
    when PV_COUNT_LV3_THRESHOLD
      return if pv_count_lv3?

      update!(pv_count_lv3: true)
    when PV_COUNT_LV4_THRESHOLD
      return if pv_count_lv4?

      update!(pv_count_lv4: true)
    end
  end

  # いいね数の実績 ---------
  def judge_like_count!
    case user.plan_likes.except_plan_user.count
    when LIKE_COUNT_LV1_THRESHOLD
      return if like_count_lv1?

      update!(like_count_lv1: true)
    when LIKE_COUNT_LV2_THRESHOLD
      return if like_count_lv2?

      update!(like_count_lv2: true)
    when LIKE_COUNT_LV3_THRESHOLD
      return if like_count_lv3?

      update!(like_count_lv3: true)
    when LIKE_COUNT_LV4_THRESHOLD
      return if like_count_lv4?

      update!(like_count_lv4: true)
    end
  end

  # コメント数の実績 ---------
  def judge_comment_count!
    case user.plan_comments.except_plan_user.count
    when COMMENT_COUNT_LV1_THRESHOLD
      return if comment_count_lv1?

      update!(comment_count_lv1: true)
    when COMMENT_COUNT_LV2_THRESHOLD
      return if comment_count_lv2?

      update!(comment_count_lv2: true)
    when COMMENT_COUNT_LV3_THRESHOLD
      return if comment_count_lv3?

      update!(comment_count_lv3: true)
    when COMMENT_COUNT_LV4_THRESHOLD
      return if comment_count_lv4?

      update!(comment_count_lv4: true)
    end
  end
end
