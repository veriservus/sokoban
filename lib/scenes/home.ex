defmodule Sokoban.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Sokoban.Map

  #import Scenic.Primitives

  def init(scene, _param, _opts) do
    #{width, height} = scene.viewport.size

    graph =
      Graph.build()
      |> Map.draw()

    scene = push_graph(scene, graph)

    {:ok, scene}
  end

  def handle_input(event, _context, scene) do
    Logger.info("Received event: #{inspect(event)}")
    {:noreply, scene}
  end
end
