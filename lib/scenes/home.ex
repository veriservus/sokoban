defmodule Sokoban.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Sokoban.Map
  alias Sokoban.Undo

  @max_undo 1000

  @impl Scenic.Scene
  def init(scene, _param, _opts) do
    request_input(scene, [:key])

    #map = Map.level0()
    map = Map.level1()
    undo = Undo.add(Undo.new(@max_undo), map)
    {:ok, draw(scene, map, undo)}
  end

  @impl Scenic.Scene
  def handle_input({:key, {:key_u, mode, _}}, _id, %{assigns: %{undo: undo}} = scene) when mode == 1 or mode == 2 do
    case Undo.undo(undo) do
      {nil, _} -> {:noreply, scene}
      {map, new_undo} -> {:noreply, draw(scene, map, new_undo)}
    end
  end

  def handle_input({:key, {:key_r, mode, _}}, _id, %{assigns: %{undo: undo}} = scene) when mode == 1 or mode == 2 do
    case Undo.redo(undo) do
      {nil, _} -> {:noreply, scene}
      {map, new_undo} -> {:noreply, draw(scene, map, new_undo)}
    end
  end

  def handle_input({:key, {direction, mode, _}}, _id, %{assigns: %{map: map, undo: undo}} = scene) when mode == 1 or mode == 2 do
    new_map = Map.move(map, direction)

    if new_map !== map do
      new_undo = Undo.add(undo, new_map)
      {:noreply, draw(scene, new_map, new_undo)}
    else
      {:noreply, scene}
    end
  end

  def handle_input(input, _id, scene) do
    Logger.info("Ignoring #{inspect(input)}")
    {:noreply, scene}
  end

  defp draw(scene, map, undo) do
    graph =
      Graph.build()
      |> Map.draw(map)

    scene
      |> assign(map: map, undo: undo)
      |> push_graph(graph)
  end
end
