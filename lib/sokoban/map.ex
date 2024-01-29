defmodule Sokoban.Map do
  import Scenic.Primitives

  require Logger

  @tile_size 64
  @air '-'
  @wall '#'
  @box 'o'
  @hero '*'
  @hole'@'
  @box_hole 'x'
  @hero_hole '+'


  def level1() do
    [
      '----#####----------',
      '----#---#----------',
      '----#o--#----------',
      '--###--o##---------',
      '--#--o-o-#---------',
      '###-#-##-#---######',
      '#---#-##-#####--@@#',
      '#-o--o----------@@#',
      '#####-###-#*##--@@#',
      '----#-----#########',
      '----#######--------'
    ]
  end

  def make_tile(graph, @air, pos) do
    make_tile(graph, :air, pos)
  end

  def make_tile(graph, @wall, pos) do
    make_tile(graph, :wall, pos)
  end

  def make_tile(graph, @hero, pos) do
    make_tile(graph, :hero, pos)
  end

  def make_tile(graph, @hero_hole, pos) do
    make_tile(graph, :hero, pos)
  end

  def make_tile(graph, @box, pos) do
    make_tile(graph, :box, pos)
  end

  def make_tile(graph, @box_hole, pos) do
    make_tile(graph, :box_hole, pos)
  end

  def make_tile(graph, @hole, pos) do
    make_tile(graph, :hole, pos)
  end

  def make_tile(graph, :air, _) do
    graph
  end

  def make_tile(graph, fill, {x, y}) do
    rect(graph, {@tile_size, @tile_size}, fill: {:image, fill}, translate: {x*@tile_size, y*@tile_size})
  end

  def draw(graph) do
    {_, graph} = Enum.reduce(level1(), {{0, 0}, graph}, fn row, {{x, y}, graph} ->
      {{_, y}, graph} = Enum.reduce(row, {{x, y}, graph}, fn tile, {{x, y}=pos, graph} ->
        {{x+1, y}, graph |> make_tile([tile], pos)}
      end)
      {{0, y+1}, graph}
    end)
    graph
  end
end
