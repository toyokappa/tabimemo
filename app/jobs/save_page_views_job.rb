class SavePageViewsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    yesterday = "i#{Date.yesterday.strftime('%Y_%m_%d')}"
    pvs = Redis::SortedSet.new("plan::#{yesterday}")
    pvs.value(with_scores: true).each do |value, score|
      PageView.create(count: score.to_i, date: Date.yesterday, plan_id: value.to_i)
    end
    pvs.clear
  end
end
