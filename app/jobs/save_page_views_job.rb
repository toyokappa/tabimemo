class SavePageViewsJob < ApplicationJob
  queue_as :default

  def perform
    # 前日のPVをDBに保存
    Plan.pv.value(with_scores: true).each do |plan_id, count|
      PageView.create(count: count.to_i, date: Date.yesterday, plan_id: plan_id.to_i)
    end
    Plan.pv.clear
  end
end
