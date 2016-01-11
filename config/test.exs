use Mix.Config

config :fulcrum,
  endpoint: "https://api.fulcrumapp.com/api/v2",
  api_key: "-"

# Print only warnings and errors during test
config :logger, level: :debug #:warn
