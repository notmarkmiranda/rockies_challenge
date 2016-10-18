class PagesController < ApplicationController
  def index
    exclusion = ["AL All-Stars", "AL Champion", "Bees", "Canada Jr. Team",
      "Chihuahuas", "Hurricanes", "NL All-Stars", "NL Champion",
      "Phillies Futures", "River Cats", "Shuckers", "Wildcats", "Cuba",
      "Owls", "Panthers"]
    @teams = Team.where.not(name: exclusion)
  end
end
