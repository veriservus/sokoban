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

  def make_tile(graph, @air, x, y) do
    make_tile(graph, :air, x, y)
  end

  def make_tile(graph, @wall, x, y) do
    make_tile(graph, :wall, x, y)
  end

  def make_tile(graph, @hero, x, y) do
    make_tile(graph, :hero, x, y)
  end

  def make_tile(graph, @hero_hole, x, y) do
    make_tile(graph, :hero, x, y)
  end

  def make_tile(graph, @box, x, y) do
    make_tile(graph, :box, x, y)
  end

  def make_tile(graph, @box_hole, x, y) do
    make_tile(graph, :box_hole, x, y)
  end

  def make_tile(graph, @hole, x, y) do
    make_tile(graph, :hole, x, y)
  end

  def make_tile(graph, :air, _, _) do
    graph
  end

  def make_tile(graph, fill, x, y) do
    rect(graph, {@tile_size, @tile_size}, fill: {:image, fill}, translate: {x*@tile_size, y*@tile_size})
  end

  def draw(graph) do
    {_, graph} = Enum.reduce(level1(), {{0, 0}, graph}, fn row, {{x, y}, graph} ->
      {{_, y}, graph} = Enum.reduce(row, {{x, y}, graph}, fn tile, {{x, y}, graph} ->
        {{x+1, y}, graph |> make_tile([tile], x, y)}
      end)
      {{0, y+1}, graph}
    end)
    graph
  end
end
