defmodule Telluride.PubSub.PipelineMetricsTopic do

  @topic "pipeline_metrics"

  def subscribe() do
    :ok = Phoenix.PubSub.subscribe(Telluride.PubSub, @topic)
  end

  def publish(event) when is_map(event) do
    Phoenix.PubSub.broadcast(Telluride.PubSub, @topic, {:metric, event})
  end

end
