defmodule Sokoban.Map do
  import Scenic.Primitives

  require Logger

  @tile_size 64
  @air '-'
  @wall '#'
  @box 'o'
  @hero '*'
  @hole '@'
  @box_hole 'x'
  @hero_hole '+'

  @tiles %{
    @air => :air,
    @wall => :wall,
    @box => :box,
    @hero => :hero,
    @hole => :hole,
    @box_hole => :box_hole,
    @hero_hole => :hero_hole
  }

  def level1() do
    world = [
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
    hero_pos = {11, 8}
    {hero_pos, @air, world}
  end

  def level0() do
    world = [
      '########',
      '#------#',
      '#-o-@--#',
      '#--*---#',
      '########'
    ]
    hero_pos = {3, 3}
    {hero_pos, @air, world}
  end

  def make_tile(graph, tile, pos) when is_list(tile) do
    make_tile(graph, @tiles[tile], pos)
  end

  def make_tile(graph, :air, _) do
    graph
  end

  def make_tile(graph, fill, {x, y}) do
    rect(graph, {@tile_size, @tile_size}, fill: {:image, fill}, translate: {x*@tile_size, y*@tile_size})
  end

  def move({position, _, _}=map, direction) do
    case direction do
      :key_left -> move_dir(map, position, fn {x, y} -> {x-1, y} end)
      :key_right -> move_dir(map, position, fn {x, y} -> {x+1, y} end)
      :key_up -> move_dir(map, position, fn {x, y} -> {x, y-1} end)
      :key_down -> move_dir(map, position, fn {x, y} -> {x, y+1} end)
      _ -> map
    end
  end

  def move_dir({from, standing, m} = map, from, to_f) do
    to = to_f.(from)

    case get_surrounding(m, to) do
      @air -> do_move(m, @hero, from, to, standing, @air)
      @hole -> do_move(m, @hero_hole, from, to, standing, @hole)
      @box -> move_box(map, from, to, to_f.(to), @air)
      @box_hole -> move_box(map, from, to, to_f.(to), @hole)
      _ -> map
    end
  end

  defp move_box({from, standing, m}=map, from, to, to_box, hero_standing_on) do
    case get_surrounding(m, to_box) do
      @air ->
        {_, _, b_m} = do_move(m, @box, to, to_box, @air, @air)
        do_move(b_m, @hero, from, to, standing, hero_standing_on)

      @hole ->
        {_, _, b_m} = do_move(m, @box_hole, to, to_box, @air, @air)
        do_move(b_m, @hero, from, to, standing, hero_standing_on)
      _ -> map
    end
  end

  def get_surrounding(m, {x, y}) do
    {map_row, _} = List.pop_at(m, y, [])
    {surrounding, _} = List.pop_at(map_row, x, @wall)

    [surrounding]
  end

  def do_move(m, [who], {x, y}, {to_x, to_y}=dest, [replace], new_standing) do
    new_m = m
    |> put_at({x, y}, replace)
    |> put_at({to_x, to_y}, who)

    {dest, new_standing, new_m}
  end

  def put_at(m, {x, y}, what) do
    {map_row, _} = List.pop_at(m, y)
    new_row = List.replace_at(map_row, x, what)
    List.replace_at(m, y, new_row)
  end

  def draw(graph, {_, _, map}) do
    {_, graph} = Enum.reduce(map, {{0, 0}, graph}, fn row, {{x, y}, graph} ->
      {{_, y}, graph} = Enum.reduce(row, {{x, y}, graph}, fn tile, {{x, y}=pos, graph} ->
        {{x+1, y}, graph |> make_tile([tile], pos)}
      end)
      {{0, y+1}, graph}
    end)
    graph
  end
end
