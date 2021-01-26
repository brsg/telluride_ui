defmodule TellurideWeb.SettingsComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML
  import TellurideWeb.ErrorHelpers
  alias Telluride.Pipeline.PipelineConfig

  def mount(socket) do
    {:ok, socket}
  end  

end
