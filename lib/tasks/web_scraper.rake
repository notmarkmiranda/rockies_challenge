desc "scrape days"
task scrape_days: [ :environment ] do
  `rails db:drop db:create db:migrate`

  months = ['month_03', 'month_04', 'month_05', 'month_06', 'month_07', 'month_08', 'month_09', 'month_10', 'month_11']

  months.each do |month|
    month_doc = HTTParty.get("http://gd2.mlb.com/components/game/mlb/year_2016/#{month}")
    parsed_page = Nokogiri::HTML(month_doc)
    days = process_days(parsed_page)
    cycle_days(month, days)
  end

end

def cycle_days(month, days)
  days.each do |day|
    puts "#{month} - #{day}"
    event_link = "http://gd2.mlb.com/components/game/mlb/year_2016/#{month}/#{day}"
    day_doc = HTTParty.get(event_link)
    raw_scoreboard = HTTParty.get("http://gd2.mlb.com/components/game/mlb/year_2016/#{month}/#{day}miniscoreboard.json")
    if !raw_scoreboard.include?("404")
      json_scoreboards = JSON.parse(raw_scoreboard.to_json)["data"]["games"]["game"]
      process_scoreboards(json_scoreboards, event_link)
    end
  end
end

def process_days(parsed_page)
  parsed_page.css('li').css('a').children.map do |name|
    name.text.strip if name.text.include? ("day")
  end.compact
end

def process_scoreboards(json_scoreboards, event_link)
  if json_scoreboards != nil?
    if json_scoreboards.class == Array
      json_scoreboards.each do |game|
        create_teams_and_games(game, event_link)
      end
    elsif json_scoreboards.class == Hash
      game = json_scoreboards
      create_teams_and_games(game, event_link)
    end
  end
end

def create_teams_and_games(game, event_link)
    game_id = game["game_data_directory"].split("/")[-1]
    game_type = game["game_type"]
    away = Team.find_or_create_by(name: game["away_team_name"])
    home = Team.find_or_create_by(name: game["home_team_name"])
    puts game_id
    g = MlbGame.new(game_id: game_id, game_type: game_type, home_id: home.id, away_id: away.id)
    g.save
    grab_events(g, event_link)
end

def grab_events(game, event_link)
  game_doc = HTTParty.get("#{event_link}#{game.game_id}/game_events.json")
  if !game_doc.include?("404 Not Found")
    json_game_by_inning = JSON.parse(game_doc.to_json)["data"]["game"]["inning"]
    json_game_by_inning.each do |innings|
      if innings.class == Hash
        half_innings(innings, game, "top")
        half_innings(innings, game, "bottom")
      end
    end
  end
end

def half_innings(innings, game, half)
  if innings[half]["action"] && innings[half]["action"].class == Hash
    ge = GameEvent.new(description: innings[half]["action"]["des"].strip, half: half, inning: innings["num"].to_i, mlb_game_id: game.id)
    ge.save
  elsif innings[half]["action"] && innings[half]["action"].class == Array
    innings[half]["action"].each do |inn|
      ge = GameEvent.new(description: inn["des"].strip, half: half, inning: inn["num"].to_i, mlb_game_id: game.id)
      ge.save
    end
  end
end
