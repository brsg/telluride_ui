defmodule Telluride.Messaging.PipelineMetricQueue do

  @exchange         "sensor_events"

  @msg_queue        "sensor_metric_queue"
  @msg_routing_key  "sensor.metric"

  @dlx_queue        "dlx_queue"
  @dlx_routing_key  "dlx_key"

  @prefetch_count   10

  ################################################################################
  # Public
  ################################################################################

  def exchange, do: @exchange
  def msg_queue, do: @msg_queue
  def msg_routing_key, do: @msg_routing_key
  def dlx_queue, do: @dlx_queue
  def dlx_routing_key, do: @dlx_routing_key

  def configure_producer(channel) do
    :ok = declare_queue(channel)
  end

  def register_consumer(channel) do
    :ok = declare_queue(channel)
    :ok = AMQP.Basic.qos(channel, prefetch_count: @prefetch_count)
    {:ok, _consumer_tag} = AMQP.Basic.consume(channel, @msg_queue)
    :ok
  end

  def cancel_consumer(channel, consumer_tag) do
    AMQP.Basic.cancel(channel, consumer_tag)
  end

  ################################################################################
  # Private
  ################################################################################

  defp declare_queue(channel) do

    # Declare an error queue
    {:ok, _} = AMQP.Queue.declare(
      channel,
      @dlx_queue,
      durable: true
    )

    # Declare a message queue
    {:ok, _} = AMQP.Queue.declare(
      channel,
      @msg_queue,
      durable: true,
      arguments: [
        {"x-dead-letter-exchange", @exchange},
        {"x-dead-letter-routing-key", @dlx_routing_key}
      ]
    )

    # Declare a direct exchange
    :ok = AMQP.Exchange.direct(channel, @exchange, durable: true)

    # Bind the message queue to the exchange
    :ok = AMQP.Queue.bind(channel, @msg_queue, @exchange, routing_key: @msg_routing_key)
  end

end