defmodule Sokoban.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Sokoban.Map

  @impl Scenic.Scene
  def init(scene, _param, _opts) do
    request_input(scene, [:key])

    #map = Map.level0()
    map = Map.level1()
    graph =
      Graph.build()
      |> Map.draw(map)

    scene = scene
      |> assign(graph: graph, map: map)
      |> push_graph(graph)

      {:ok, scene}
  end

  @impl Scenic.Scene
  def handle_input({:key, {direction, mode, _}}, _id, %{assigns: %{graph: _graph, map: map}} = scene) when mode == 1 or mode == 2 do
    new_map = Map.move(map, direction)

    graph =
      Graph.build()
      |> Map.draw(new_map)

    new_scene = scene
      |> assign(graph: graph, map: new_map)
      |> push_graph(graph)

    {new_pos, _, _} = new_map

    Logger.warning("New hero pos is #{inspect(new_pos)}")

    {:noreply, new_scene}
  end

  def handle_input(input, _id, scene) do
    Logger.info("Ignoring #{inspect(input)}")
    {:noreply, scene}
  end
end
