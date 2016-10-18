class Team < ApplicationRecord
  has_many :home_games, class_name: "MlbGame",
                        foreign_key: "home_id"
  has_many :away_games, class_name: "MlbGame",
                        foreign_key: "away_id"
end
