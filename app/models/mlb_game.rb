class MlbGame < ApplicationRecord
  has_many :game_events
  belongs_to :away, class_name: "Team"
  belongs_to :home, class_name: "Team"
end
