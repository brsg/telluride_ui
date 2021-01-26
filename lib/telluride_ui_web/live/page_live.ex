defmodule TellurideWeb.PageLive do
  use TellurideWeb, :live_view

  alias Telluride.Pipeline.PipelineConfig

  @impl true
  def mount(_params, _session, socket) do
    config = %PipelineConfig{producer_count: 1, processor_count: 1}
    {:ok, assign(socket, %{changeset: PipelineConfig.changeset(config)})}
  end

  @impl true
  def handle_event("validate", args, socket) do
    IO.puts("PageLive got validate event with args #{inspect args, pretty: true}")
    changeset =
      %PipelineConfig{}
      |> PipelineConfig.changeset(args)
      |> Map.put(:action, :insert)
    IO.puts("validate sending changeset=#{inspect changeset, pretty: true}")
    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", args, socket) do
    IO.puts("PageLive got save event with args #{inspect args, pretty: true}")
    changeset =
      %PipelineConfig{}
      |> PipelineConfig.changeset(args)
      |> Map.put(:action, :insert)
      IO.puts("changeset=#{inspect changeset, pretty: true}")
      {:noreply, assign(socket, changeset: changeset)}
  end

end
