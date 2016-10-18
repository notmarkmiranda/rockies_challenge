class Team < ApplicationRecord
  default_scope { order('name ASC') }
  has_many :home_games, class_name: "MlbGame",
                        foreign_key: "home_id"
  has_many :away_games, class_name: "MlbGame",
                        foreign_key: "away_id"

  def total_mound_visits
    home_mound_visits + away_mound_visits
  end

  def home_mound_visits
    home_games.where(game_type: "R").joins(:game_events).
      where("game_events.description LIKE ?", "%visit to mound%").
      where("game_events.half = ?", "bottom").all.count
  end

  def away_mound_visits
    away_games.where(game_type: "R").joins(:game_events).
      where("game_events.description LIKE ?", "%visit to mound%").
      where("game_events.half = ?", "top").all.count
  end
end
