use Mix.Config

config :fulcrum,
  endpoint: "https://api.fulcrumapp.com/api/v2"

# your dev.secret.exs should look something like:
# use Mix.Config
# config :fulcrum,
#   api_key: "<the api key you generated on the fulcrum site>"

# ...or (e.g. for Heroku)
# config :fulcrum,
#   api_key: System.get_env("FULCRUM_KEY")

# Print only warnings and errors during test
config :logger, level: :warn
