# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :fulcrum,
  endpoint: "https://api.fulcrumapp.com/api/v2",
  api_key: System.get_env("FULCRUM_API_KEY")

import_config "#{Mix.env}.exs"

