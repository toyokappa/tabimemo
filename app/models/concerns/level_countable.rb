module LevelCountable
  extend ActiveSupport::Concern

  LEVEL_TABLE = [
    # 1 ~ 10
    0, 10, 30, 60, 100, 150, 230, 350, 500, 700,
    # 11 ~ 20
    950, 1200, 1500, 1800, 2300, 2800, 3500, 4200, 5000, 6000,
    # 21 ~ 30
    7000, 8000, 10000, 13000, 16000, 20000, 25000, 30000, 36000, 42000,
    # 31 ~ 40
    48000, 54000, 60000, 70000, 80000, 90000, 100000, 115000, 130000, 145000,
  ]

  def obtain_exp!
    self.class.transaction do
      update!(exp: calc_exp)
      level_up!
    end
  end

  def next_level_exp
    # 最大レベルまで達している場合は-1を返す
    LEVEL_TABLE[level] || -1
  end

  def next_level_exp_rate
    return 0 if exp <= current_level_exp

    ((exp - current_level_exp).to_f / (next_level_exp - current_level_exp) * 100).round(1)
  end

  private

    def calc_exp
      plans.published.sum do |plan|
        total = plan.spots.count >= 5 ? 30 : 10
        total += plan.photos.count * 1
        total += plan.likes.except_plan_user.count * 2
      end
    end

    def level_up!
      # 上限経験値を越えている場合、レベルアップしない
      return false if LEVEL_TABLE.last <= exp
      return false if level >= next_level

      update!(level: next_level)
    end

    def next_level
      prev_threshold = 0
      LEVEL_TABLE.index do |threshold|
        next if threshold == prev_threshold

        if prev_threshold <= exp && exp < threshold
          true
        else
          prev_threshold = threshold
          false
        end
      end
    end

    def current_level_exp
      LEVEL_TABLE[level - 1]
    end
end
