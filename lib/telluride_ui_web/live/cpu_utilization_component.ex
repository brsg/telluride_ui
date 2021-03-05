defmodule TellurideWeb.CpuUtilizationComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  alias Contex.{BarChart, Plot, Dataset}

  @interval_ms 1_000

  ################################################################################
  # LiveView callbacks
  ################################################################################

  @impl true
  def mount(socket) do
    {:ok, assign_cpu_metrics(socket)}
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_cpu_metrics()
     |> assign_dataset()
     |> assign_chart()
     |> assign_svg()
     |> schedule_monitor_task()
    }
  end
  
  ################################################################################
  # Private
  ################################################################################

  defp assign_cpu_metrics(socket) do
    metrics_by_core = :cpu_sup.util([:per_cpu])
    busy_by_cpu = Enum.map(metrics_by_core, fn {cpu, busy, idle, misc} -> {cpu, busy} end)
    socket
    |> assign(:metrics_by_core, busy_by_cpu)
  end

  defp assign_dataset(%{assigns: %{metrics_by_core: metrics_by_core}} = socket) do
    socket
    |> assign(:dataset, Contex.Dataset.new(metrics_by_core))
  end

  defp assign_chart(%{assigns: %{dataset: dataset}} = socket) do
    socket
    |> assign(
       :chart,
       BarChart.new(dataset)
       |> BarChart.data_labels(false)
       |> BarChart.force_value_range({0, 100})
      )
  end

  defp assign_svg(%{assigns: %{chart: chart}} = socket) do
    options = %{
      orientation: :horizontal,
      colour_palette: ["ff9838", "fdae53", "fbc26f", "fad48e", "fbe5af", "fff5d1"],
    }
    socket
    |> assign(
      :chart_svg,
      Plot.new(280, 200, chart)
      |> Plot.plot_options(options)
      # |> Plot.titles("CPU Utilization", "% of CPU Cycles Used, By Core")
      |> Plot.axis_labels("CPU", "% Utilization")
      |> Plot.to_svg())
  end

  defp schedule_monitor_task(socket) do
    Process.send_after(self(), :monitor, @interval_ms)
    socket
  end

end