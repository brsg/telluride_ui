defmodule Telluride.Repo do
  use Ecto.Repo,
    otp_app: :telluride_ui,
    adapter: Ecto.Adapters.Postgres
end
