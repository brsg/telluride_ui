defmodule TellurideWeb.PageLive do
  use TellurideWeb, :live_view

  import Ecto.Changeset

  alias Ecto.Changeset
  alias Telluride.Pipeline.Pipeline
  alias Telluride.PubSub.PipelineMetricsTopic
  alias Telluride.PubSub.PipelineThroughputTopic
  alias Telluride.Messaging.PipelineConfigProducer

  ################################################################################
  # LiveView callbacks
  ################################################################################

  @impl true
  def mount(_params, _session, socket) do

    PipelineMetricsTopic.subscribe()
    PipelineThroughputTopic.subscribe()

    pipeline = Pipeline.new()
    changeset = change(pipeline)

    socket = socket
    |> assign(:changeset, changeset)
    |> assign(:pipeline, pipeline)
    |> assign(:metrics, initial_metrics())

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", args, socket) do
    changeset =
      Pipeline.new()
      |> Pipeline.changeset(args)
      |> Map.put(:action, :insert)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", args, socket) do
    socket = case save_pipeline_config(args) do
      {:ok, pipeline} ->
        restart_pipeline(pipeline)
        assign(socket, :pipeline, pipeline)
      {:error, changeset} ->
        assign(socket, :changeset, changeset)
    end
    {:noreply, socket}
  end

  @impl true
  def handle_info({:metric, event}, socket) do
    {:noreply, update_node_status(event, socket)}
  end

  @impl true
  def handle_info({:throughput, event}, socket) do
    {:noreply, update_metrics(event, socket)}
  end

  ################################################################################
  # Private
  ################################################################################

  defp save_pipeline_config(args) do
    case Pipeline.changeset(Pipeline.new(), args) do
      %{valid?: true} = changeset -> 
        changeset
        |> apply_action(:insert)
      changeset ->
        changeset = Map.put(changeset, :action, :insert)
        {:error, changeset}
    end
  end

  defp restart_pipeline(pipeline) do
    message = %{
      sensor_batcher_one_batch_size: pipeline.batcher1_batch_size,
      sensor_batcher_one_concurrency: pipeline.batcher1_concurrency,
      sensor_batcher_two_batch_size: pipeline.batcher2_batch_size,
      sensor_batcher_two_concurrency: pipeline.batcher2_concurrency,
      processor_concurrency: pipeline.processor_concurrency,
      producer_concurrency: pipeline.producer_concurrency,
      rate_limit_allowed: pipeline.rate_limit_allowed,
      rate_limit_interval: pipeline.rate_limit_interval
    }
    PipelineConfigProducer.publish(message)
  end

  defp update_node_status(%{"node_type" => "producer", "partition" => partition, "mean_duration" => mean_duration} = event, socket) do
    update_node_status("producer_#{partition}", event, socket)
  end

  defp update_node_status(%{"node_type" => "processor", "partition" => partition, "mean_duration" => mean_duration} = event, socket) do
    update_node_status("processor_#{partition}", event, socket)
  end

  defp update_node_status(%{"node_type" => "batcher", "name" => "sensor_batcher_one", "partition" => partition, "mean_duration" => mean_duration} = event, socket) do
    update_node_status("batcher_1", event, socket)
  end

  defp update_node_status(%{"node_type" => "batcher", "name" => "sensor_batcher_two", "partition" => partition, "mean_duration" => mean_duration} = event, socket) do
    update_node_status("batcher_2", event, socket)
  end

  defp update_node_status(%{"node_type" => "batcher_processor", "name" => "sensor_batcher_one", "partition" => partition, "mean_duration" => mean_duration} = event, socket) do
    update_node_status("batcher_1_processor_#{partition}", event, socket)
  end

  defp update_node_status(%{"node_type" => "batcher_processor", "name" => "sensor_batcher_two", "partition" => partition, "mean_duration" => mean_duration} = event, socket) do
    update_node_status("batcher_2_processor_#{partition}", event, socket)
  end

  defp update_node_status(event, socket) do
    IO.puts("\n\nupdate_node_status(#{inspect event, pretty: true}, socket}")
    socket
  end

  defp update_node_status(key, %{"mean_duration" => mean_duration} = event, socket) do
    status = compute_status(mean_duration)
    pipeline = socket.assigns.pipeline
    pipeline = put_in(pipeline.node_status[key], status)
    assign(socket, :pipeline, pipeline)
  end

  defp compute_status(microseconds) when microseconds <= 100_000, do: "border-normal"
  defp compute_status(microseconds) when microseconds > 100_000 and microseconds < 200_000, do: "border-warning"
  defp compute_status(microseconds) when microseconds >= 200_000, do: "border-error"

  defp update_metrics(event, socket) do
    %{
      "earliest_raw_time" => earliest_raw_time, 
      "last_raw_time" => last_raw_time, 
      "total_failed_count" => total_failed_count, 
      "total_message_count" => total_message_count, 
      "total_successful_count" => total_successful_count
    } = event

    elapsed_time_monotonic = last_raw_time - earliest_raw_time
    elapsed_time_seconds = :erlang.convert_time_unit(elapsed_time_monotonic, :native, :second)
    messages_per_second = Float.round(total_message_count / elapsed_time_seconds, 1)

    percent_successful = total_successful_count / total_message_count * 100.0

    assign(socket, :metrics, %{throughput: messages_per_second, total_message_count: total_message_count, percent_successful: percent_successful})
  end

  defp initial_metrics do
    %{
      throughput: 0,
      total_message_count: 0,
      percent_successful: 100.0
    }
  end

end
