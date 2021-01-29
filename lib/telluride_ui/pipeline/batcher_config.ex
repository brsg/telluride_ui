defmodule Telluride.Pipeline.BatcherConfig do
  use Ecto.Schema
  import Ecto.Changeset
  alias Telluride.Pipeline.BatcherConfig

  embedded_schema do
    field :batch_key, :string
    field :processor_count, :integer
  end

  def new do
    %BatcherConfig{batch_key: "", processor_count: 1}
  end

  @doc false
  def creation_changeset(%BatcherConfig{} = batcher_config, attrs) do
    batcher_config
    |> cast(attrs, [:batch_key, :processor_count])
    |> validate_required([:batch_key, :processor_count])
  end
  
end
