defmodule Telluride.PubSub.PipelineThroughputTopic do

  @topic "pipeline_throughput"

  def subscribe() do
    :ok = Phoenix.PubSub.subscribe(Telluride.PubSub, @topic)
  end

  def publish(event) when is_map(event) do
    Phoenix.PubSub.broadcast(Telluride.PubSub, @topic, {:throughput, event})
  end

end
