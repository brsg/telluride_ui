defmodule Telluride.Messaging.AMQPConnectionManager do
  use GenServer
  use AMQP

  ################################################################################
  # Client interface
  ################################################################################

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, [name: __MODULE__])
  end

  def get_connection do
    case GenServer.call(__MODULE__, :get) do
      nil -> {:error, :not_connected}
      conn -> {:ok, conn}
    end
  end

  def request_channel(consumer) do
    GenServer.cast(__MODULE__, {:chan_request, consumer})
  end

  ################################################################################
  # Server callbacks
  ################################################################################

  @impl
  def init(init_arg) do
    Supervisor.start_link(init_arg, strategy: :one_for_one, name: Telluride.Messaging.AMQPConsumerSupervisor)
    establish_new_connection()
  end

  def handle_call(:get, _, conn) do
    {:reply, conn, conn}
  end

  def handle_cast({:chan_request, consumer}, {conn, channel_mappings}) do
    new_mapping = store_channel_mapping(conn, consumer, channel_mappings)
    channel = Map.get(new_mapping, consumer)
    consumer.channel_available(channel)
    {:noreply, {conn, new_mapping}}
  end

  def handle_info({:DOWN, _, :process, _pid, reason}, _) do
    {:stop, {:connection_lost, reason}, nil}
  end

  ################################################################################
  # Private
  ################################################################################

  defp establish_new_connection do
    case AMQP.Connection.open(connection_options()) do
      {:ok, conn} ->
        Process.link conn.pid
        {:ok, {conn, %{}}}
      {:error, reason} ->
        IO.puts "failed for #{inspect reason}"
        :timer.sleep 5000
        establish_new_connection()
    end
  end

  defp connection_options() do
    [
      host: "localhost",
#      port: 5672,
#      virtual_host: "/",
#      username: "guest",
#      password: "guest"
    ]
  end

  defp store_channel_mapping(conn, consumer, channel_mappings) do
    Map.put_new_lazy(channel_mappings, consumer, fn() -> create_channel(conn) end)
  end

  defp create_channel(conn) do
    {:ok, chan} = Channel.open(conn)
    chan
  end

end
