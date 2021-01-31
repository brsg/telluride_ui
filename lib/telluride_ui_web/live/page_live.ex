defmodule TellurideWeb.PageLive do
  use TellurideWeb, :live_view

  alias Ecto.Changeset
  alias Telluride.Pipeline.PipelineConfig

  @impl true
  def mount(_params, _session, socket) do
    pipeline = PipelineConfig.new()
    changeset = Changeset.change(pipeline)
    {:ok, assign(socket, pipeline: pipeline, changeset: changeset)}
  end

  @impl true
  def handle_info(message, socket) do
    IO.puts("\nPageLive.handle_info - message=#{inspect message}")
    {:noreply, assign(socket, pipeline: message)}
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
