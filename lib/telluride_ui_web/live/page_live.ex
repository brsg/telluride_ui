defmodule TellurideWeb.PageLive do
  use TellurideWeb, :live_view

  alias Ecto.Changeset
  alias Telluride.Pipeline.BatcherConfig
  alias Telluride.Pipeline.PipelineConfig

  @impl true
  def mount(_params, _session, socket) do
    changeset = Changeset.change(PipelineConfig.new())
    {:ok, assign(socket, %{changeset: changeset})}
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

  @impl true
  def handle_event("add_batcher", _value, %{assigns: %{changeset: changeset}} = socket) do
    IO.puts("PageLive got add_batcher event with changeset #{inspect changeset.data, pretty: true}")
    pipelineConfig = changeset.data
    new_batchers = [BatcherConfig.new() | pipelineConfig.batchers]
    changeset =
      pipelineConfig
      |> PipelineConfig.changeset(%{})
      |> Changeset.put_embed(:batchers, new_batchers)
    IO.puts("updated changeset = #{inspect changeset, pretty: true}")
    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("delete_batcher", value, socket) do
    IO.puts("PageLive got delete_batcher event with value #{inspect value, pretty: true}")
    {:noreply, socket}
  end

end
