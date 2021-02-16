defmodule TellurideWeb.PageLive do
  use TellurideWeb, :live_view

  alias Ecto.Changeset
  alias Telluride.Pipeline.PipelineConfig
  alias Telluride.PubSub.PipelineMetricsTopic

  @impl true
  def mount(_params, _session, socket) do
    PipelineMetricsTopic.subscribe()
    pipeline = PipelineConfig.new()
    changeset = Changeset.change(pipeline)
    {:ok, assign(socket, pipeline: pipeline, changeset: changeset)}
  end

  @impl true
  def handle_info({:metric, event}, socket) do
    %{
      "call_count" => call_count, #293, 
      "first_time" => first_time, #-576460750783249000, 
      "last_duration" => last_duration, #260000, 
      "last_time" => last_time, #-576460114617524115, 
      "max_duration" => max_duration, #406000, 
      "mean_duration" => mean_duration, #147621.16040955635, 
      "min_duration" => min_duration, #43000, 
      "msg_count" => msg_count, #297, 
      "name" => name, #"sensor_batcher_one", 
      "partition" => partition, #0
    } = event

    # I believe we spoke about mean_duration being the key for how to 
    # paint the node.  < 1_000_000 microseconds is green, < 1_000_001
    # and less than ??? is yellow, etc.

    IO.puts("\nPageLive.handle_info(:metric) - event=#{inspect event}")
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", args, socket) do
    IO.puts("\nPageLive.handle_event - event=validate, args=#{inspect args}")
    changeset =
      %PipelineConfig{}
      |> PipelineConfig.changeset(args)
      |> Map.put(:action, :insert)
    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", args, socket) do
    IO.puts("\nPageLive.handle_event - event=save, args=#{inspect args}")
    changeset =
      %PipelineConfig{}
      |> PipelineConfig.changeset(args)
      |> Map.put(:action, :insert)
    socket =
      socket
      |> assign(:changeset, changeset)
      |> assign_pipeline(changeset)
    {:noreply, socket}
  end

  defp assign_pipeline(socket, changeset) when changeset.valid? do
    IO.puts("\nPageLive.assign_pipeline - changeset=#{inspect changeset, pretty: true}")
    pipeline = Changeset.apply_changes(changeset)
    assign(socket, pipeline: pipeline)
  end

  defp assign_pipeline(socket, changeset), do: socket

  @impl true
  def handle_event(event, args, socket) do
    IO.puts("\nPageLive.handle_event - event=#{inspect event}, args=#{inspect args}")
    {:noreply, socket}
  end

end
