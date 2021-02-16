defmodule Telluride.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Telluride.Repo,
      TellurideWeb.Telemetry,
      {Phoenix.PubSub, name: Telluride.PubSub},
      TellurideWeb.Endpoint,
      %{
        id: AMQPConnectionManager,
        start: {
          Telluride.Messaging.AMQPConnectionManager,
          :start_link,
          [[
            Telluride.Messaging.PipelineMetricConsumer
          ]]
        }
      }
    ]

    opts = [strategy: :one_for_one, name: Telluride.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    TellurideWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
