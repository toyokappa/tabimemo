class SavePageViewsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    yesterday = "pv#{Date.yesterday.strftime('%Y_%m_%d')}"
    yesterday_pv = Plan.send(yesterday)
    today = "pv#{Date.today.strftime('%Y_%m_%d')}"
    Plan.sorted_set today, global: true
    today_pv = Plan.send(today)
    display_pv = Plan.display_pv

    # 前日のPVをDBに保存
    yesterday_pv.value(with_scores: true).each do |value, score|
      PageView.create(count: score.to_i, date: Date.yesterday, plan_id: value.to_i)
    end
    yesterday_pv.clear

    # 当日のPVを表示用PVにコピー
    display_pv.clear
    if today_pv.present?
      display_pv.merge today_pv.value(with_scores: true)
    end
  end
end
