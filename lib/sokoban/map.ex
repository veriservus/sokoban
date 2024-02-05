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

  def move({position, _, _}=map, direction) do
    case direction do
      :key_left -> move_dir(map, position, &d_left/1)
      :key_right -> move_dir(map, position, &d_right/1)
      :key_up -> move_dir(map, position, &d_up/1)
      :key_down -> move_dir(map, position, &d_down/1)
      _ -> map
    end
  end

  def d_left({x, y}) do
    {x-1, y}
  end

  def d_right({x, y}) do
    {x+1, y}
  end

  def d_up({x, y}) do
    {x, y-1}
  end

  def d_down({x, y}) do
    {x, y+1}
  end

  def move_dir({from, standing, m} = map, from, to_f) do
    to = to_f.(from)
    Logger.warning("Moving from #{inspect(from)} to #{inspect(to)}")
    case get_surrounding(m, to) do
      @air -> do_move(m, @hero, from, to, standing, @air)
      @hole -> do_move(m, @hero, from, to, standing, @hole)
      @box -> case get_surrounding(m, to_f.(to)) do
        @air ->
          {_, _, b_m} = do_move(m, @box, to, to_f.(to), @air, @air)
          do_move(b_m, @hero, from, to, standing, @air)

        @hole ->
          {_, _, b_m} = do_move(m, @box_hole, to, to_f.(to), @air, @air)
          do_move(b_m, @hero, from, to, standing, @air)
        _ -> map
      end

      @box_hole -> case get_surrounding(m, to_f.(to)) do
        @air ->
          {_, _, b_m} = do_move(m, @box, to, to_f.(to), @air, @air)
          do_move(b_m, @hero, from, to, standing, @hole)

        @hole ->
          {_, _, b_m} = do_move(m, @box_hole, to, to_f.(to), @air, @air)
          do_move(b_m, @hero, from, to, standing, @hole)
        _ -> map
      end

      _ -> map
    end
  end

  def get_surrounding(m, {x, y}) do
    {map_row, _} = List.pop_at(m, y, [])
    {surrounding, _} = List.pop_at(map_row, x, @wall)
    Logger.warning("Surrounding of #{inspect({x,y})} is #{[surrounding]}")
    [surrounding]
  end

  def do_move(m, [who], {x, y}, {to_x, to_y}=dest, [replace], new_standing) do
    new_m = m
    |> put_at({x, y}, replace)
    |> put_at({to_x, to_y}, who)

    Logger.warning("Makine a move to #{inspect(dest)}")

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
