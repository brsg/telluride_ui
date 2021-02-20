defmodule Telluride.Pipeline.Pipeline do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  embedded_schema do
    field :producer_concurrency, :integer
    field :processor_concurrency, :integer
    field :batcher1_concurrency, :integer
    field :batcher2_concurrency, :integer
    field :batcher1_batch_size, :integer
    field :batcher2_batch_size, :integer
    field :rate_limit_allowed, :integer
    field :rate_limit_interval, :integer
    field :node_status, :map
  end

  def new do
    %Pipeline{
      producer_concurrency: 4,
      processor_concurrency: 4,
      batcher1_concurrency: 4,
      batcher2_concurrency: 4,
      batcher1_batch_size: 10,
      batcher2_batch_size: 10,
      rate_limit_allowed: 5_000,
      rate_limit_interval: 1_000,
      node_status: %{}
    }
  end

  @doc false
  def changeset(%Pipeline{} = pipeline, attrs \\ %{}) do

    pipeline
    |> cast(attrs, [
      :producer_concurrency,
      :processor_concurrency,
      :batcher1_concurrency,
      :batcher2_concurrency,
      :batcher1_batch_size,
      :batcher2_batch_size,
      :rate_limit_allowed,
      :rate_limit_interval,
      :node_status
    ])
    |> validate_required([
      :producer_concurrency,
      :processor_concurrency,
      :batcher1_concurrency,
      :batcher2_concurrency,
      :batcher1_batch_size,
      :batcher2_batch_size,
      :rate_limit_allowed,
      :rate_limit_interval,
    ])
    |> validate_number(:producer_concurrency, greater_than: 0)
    |> validate_number(:processor_concurrency, greater_than: 0)
    |> validate_number(:batcher1_concurrency, greater_than: 0)
    |> validate_number(:batcher2_concurrency, greater_than: 0)
    |> validate_number(:batcher1_batch_size, greater_than: 0)
    |> validate_number(:batcher2_batch_size, greater_than: 0)
    |> validate_number(:rate_limit_allowed, greater_than: 0)
    |> validate_number(:rate_limit_interval, greater_than: 0)
  end

end
