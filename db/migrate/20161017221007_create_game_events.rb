class CreateGameEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :game_events do |t|
      t.string :description
      t.string :half
      t.integer :inning
      t.references :mlb_game, foreign_key: true
    end
  end
end
