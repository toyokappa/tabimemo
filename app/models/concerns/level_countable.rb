module LevelCountable
  extend ActiveSupport::Concern

  LEVEL_TABLE = [
    # 1 ~ 10
    0, 10, 30, 60, 100, 150, 230, 350, 500, 700,
    # 11 ~ 20
    950, 1200, 1500, 1800, 2300, 2800, 3500, 4200, 5000, 6000
  ]

  def level
    # 上限経験値を越えている場合、最大レベルを表示する
    return LEVEL_TABLE.length if LEVEL_TABLE.last <= experience_point

    prev_exp = 0
    LEVEL_TABLE.index do |exp|
      next if exp == prev_exp

      if prev_exp <= experience_point && experience_point < exp
        true
      else
        prev_exp = exp
        false
      end
    end
  end

  def next_level_exp
    # 最大レベルまで達している場合は-1を返す
    LEVEL_TABLE[level] || -1
  end
end
