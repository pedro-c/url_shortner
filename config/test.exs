use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :UrlShortener, UrlShortenerWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
# uncomment below to get some more debug messages if required
# config :logger, level: :warn, handle_otp_reports: true, handle_sasl_reports: true

# Configure your database
config :UrlShortener, UrlShortener.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATA_DB_USER"),
  password: System.get_env("DATA_DB_PASS"),
  hostname: System.get_env("DATA_DB_HOST"),
  database: "gonano",
  pool_size: 10,
  pool: Ecto.Adapters.SQL.Sandbox

 config :UrlShortener, :github_api, UrlShortener.GitHub.Test
