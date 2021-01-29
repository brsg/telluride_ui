defmodule Telluride.Pipeline.PipelineConfig do
  use Ecto.Schema
  import Ecto.Changeset

  alias Telluride.Pipeline.PipelineConfig

  embedded_schema do
    field :producer_concurrency, :integer
    field :processor_concurrency, :integer
    field :batcher1_concurrency, :integer
    field :batcher2_concurrency, :integer
    field :batcher3_concurrency, :integer
    field :batcher1_batch_size, :integer
    field :batcher2_batch_size, :integer
    field :batcher2_batch_size, :integer
  end

  def new do
    %PipelineConfig{
      producer_concurrency: 1,
      processor_concurrency: 1,
      batcher1_concurrency: 1,
      batcher2_concurrency: 1,
      batcher2_concurrency: 1,
      batcher1_batch_size: 1,
      batcher2_batch_size: 1,
      batcher3_batch_size: 1
    }
  end

  @doc false
  def changeset(%PipelineConfig{} = pipeline_config, attrs \\ %{}) do
    IO.puts("PipelineConfig.changeset attrs #{inspect(attrs)}")

    pipeline_config
    |> cast(attrs, [
      :producer_concurrency,
      :processor_concurrency,
      :batcher1_concurrency,
      :batcher2_concurrency,
      :batcher3_concurrency,
      :batcher1_batch_size,
      :batcher2_batch_size,
      :batcher3_batch_size
    ])
    |> validate_required([
      :producer_concurrency,
      :processor_concurrency,
      :batcher1_concurrency,
      :batcher2_concurrency,
      :batcher3_concurrency,
      :batcher1_batch_size,
      :batcher2_batch_size,
      :batcher3_batch_size
    ])
  end
end
