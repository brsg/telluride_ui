defmodule Telluride.Pipeline.PipelineConfig do
  use Ecto.Schema
  import Ecto.Changeset

  alias Telluride.Pipeline.BatcherConfig
  alias Telluride.Pipeline.PipelineConfig

  embedded_schema do
    field :processor_count, :integer
    field :producer_count, :integer
    embeds_many(:batchers, BatcherConfig)
  end

  @doc false
  def changeset(%PipelineConfig{} = pipeline_config, attrs \\ %{}) do
    IO.puts("PipelineConfig.changeset attrs #{inspect attrs}")
    pipeline_config
    |> cast(attrs, [:producer_count, :processor_count])
    |> validate_required([:producer_count, :processor_count])
  end

end
