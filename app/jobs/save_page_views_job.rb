class SavePageViewsJob < ApplicationJob
  queue_as :default

  def perform
    # 前日のPVをDBに保存
    Plan.pv.value(with_scores: true).each do |plan_id, count|
      pv = PageView.find_or_initialize_by(date: Date.yesterday, plan_id: plan_id.to_i)
      pv.count = count
      pv.save!
    end
    Plan.pv.clear
  end
end
