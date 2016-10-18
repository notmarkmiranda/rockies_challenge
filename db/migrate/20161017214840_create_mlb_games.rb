class CreateMlbGames < ActiveRecord::Migration[5.0]
  def change
    create_table :mlb_games do |t|
      t.string :game_id
      t.string :game_type
      t.integer :home_id
      t.integer :away_id
    end
    add_index :mlb_games, :home_id
    add_index :mlb_games, :away_id
  end
end
