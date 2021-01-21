# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :telluride_ui,
  namespace: Telluride,
  ecto_repos: [Telluride.Repo]

# Configures the endpoint
config :telluride_ui, TellurideWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "j03ZN49rJWvzsD+91ozwZg5bP8wGYsw9NcxQtvR9SowFCJjrB22cg+8JoULUQNBQ",
  render_errors: [view: TellurideWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Telluride.PubSub,
  live_view: [signing_salt: "OCqzbA2M"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
