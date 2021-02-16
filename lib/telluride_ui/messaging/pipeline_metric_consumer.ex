defmodule Telluride.Messaging.PipelineMetricConsumer do
  use GenServer
  use AMQP

  alias Telluride.Messaging.AMQPConnectionManager
  alias Telluride.Messaging.PipelineMetricQueue

  ################################################################################
  # Client interface
  ################################################################################

  @doc """
  Start a SensorEventConsumer process
  """
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, [name: __MODULE__])
  end

  ################################################################################
  # AMQPConnectionManager callbacks
  ################################################################################

  @doc """
  Receive notification from the AMQP Connection Manager that a channel is available.
  """
  def channel_available(channel) do
    GenServer.cast(__MODULE__, {:channel_available, channel})
  end

  ################################################################################
  # GenServer callbacks
  ################################################################################

  @doc """
  Initialize this process by requesting an AMQP channel from
  the AMQP Connection Manager
  """
  @impl true
  def init(_init_arg) do
    AMQPConnectionManager.request_channel(__MODULE__)
    {:ok, nil}
  end

  @doc """
  Receive notification from the AMQP Connection Manager that
  a channel is available

  ## Parameters

    - channel: the AMQP channel allocated by the Connection Manager
  """
  @impl true
  def handle_cast({:channel_available, channel}, _state) do
    :ok = PipelineMetricQueue.register_consumer(channel)
    {:noreply, %{channel: channel}}
  end

  @doc """
  Receive confirmation from the broker that this process was registered as a consumer
  """
  @impl true
  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, %{channel: channel}) do
    {:noreply, %{channel: channel, consumer_tag: consumer_tag}}
  end

  @doc """
  Receive notification from the broker that this consumer was cancelled
  """
  @impl true
  def handle_info({:basic_cancel, _}, state) do
    {:stop, :normal, state}
  end

  @doc """
  Receive confirmation from the broker for a Basic.cancel
  """
  @impl true
  def handle_info({:basic_cancel_ok, _}, state) do
    {:noreply, state}
  end

  @doc """
  Receive notification from the broker that a message has been delivered
  """
  @impl true
  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, %{channel: channel, consumer_tag: consumer_tag} = state) do
    consume(channel, tag, redelivered, payload)
    {:noreply, state}
  end

  @doc """
  Receive notification from the broker that a message has been delivered
  """
  @impl true
  def handle_info({:quit, reason}, %{channel: channel, consumer_tag: consumer_tag} = state) do
     PipelineMetricQueue.cancel_consumer(channel, consumer_tag)
    {:stop, reason, state}
  end

  @impl true
  def terminate(reason, %{channel: channel, consumer_tag: consumer_tag} = state) do
     PipelineMetricQueue.cancel_consumer(channel, consumer_tag)
  end

  ################################################################################
  # Private
  ################################################################################

  @doc """
  Consumer a delivered message and provide acknowledgement
  """
  defp consume(channel, delivery_tag, _redelivered, payload) do
    case Jason.decode(payload) do
      {:ok, event_info} ->
        IO.puts("PipelineMetricConsumer.consume - received #{inspect event_info}")
        Telluride.PubSub.PipelineMetricsTopic.publish(event_info)
        AMQP.Basic.ack(channel, delivery_tag)
      {:error, reason} ->
        Basic.reject channel, delivery_tag, requeue: false
        IO.puts("PipelineMetricConsumer.consume - error '#{inspect reason}' processing payload: #{inspect payload}")
      err ->
        Basic.reject channel, delivery_tag, requeue: false
        IO.puts("PipelineMetricConsumer.consume - error '#{inspect err}'' processing payload: #{inspect payload}")
        err
    end
  end

end
