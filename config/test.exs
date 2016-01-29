use Mix.Config

# Print only warnings and errors during test
config :logger, level: :debug #:warn

# Configure Fulcrum request/response recording
config :exvcr, [
  vcr_cassette_library_dir: "fixture/vcr_cassettes",
  custom_cassette_library_dir: "fixture/custom_cassettes",
  filter_sensitive_data: [
    [
      pattern: System.get_env("FULCRUM_API_KEY") || "FULCRUM_API_KEY", placeholder: "FULCRUM_API_KEY"
    ]
  ],
  filter_url_params: false,
  response_headers_blacklist: []
]


