# MLB API Usage

This is a Rails app that utilizes the MLB API to display (currently 1) statistics from regular season games.

```
git clone git@github.com:notmarkmiranda/rockies_challenge.git
cd rockies_challenge
bundle
rails db:drop db:create db:migrate
rake scrape_days
```

Once the rake task is finished, navigate to ```http://localhost:3000``` in your browser. It currently shows regular season mound visits per team.

This is the schema:

![schema](https://d17oy1vhnax1f7.cloudfront.net/items/1p251t0G2c150Y2o1A2m/schema.png?v=26415996)

A live version can be seen here: https://rockies.herokuapp.com/
